.. _sec-dev-realTimeControl:

****************************************************
Real Time Control of PELE simulations (experimental)
****************************************************

This is an experimental feature to allow real time control of an already started PELE simulation, in a similar way to Changeable Parameters, but this time performing the change of parameters at the moment the user decides to issue the command. This feature is intended to be used indirectly by the user, with a middleware that will understand the user control commands and transform them into the low-level way of interacting with the PELE simulation.

For information on how to use it, check the ``Real Time Control of PELE simulations`` section in the user manual.

This feature is currently only available for MPI simulations; in those cases, only PELE simulation commands can be executed.

Main implementation elements
============================

Activation
----------

Both the MPI explorer controller must know that real time control commands are accepted, and also the explorers must know, so that they can process it.

Activation is marked as a global variable through ``SystemVars::enableRealTimeControl(boost::shared_ptr<SimulationControlCommandStream> newCommandStream)``. Since in the MPI implementation, the controller does not receive the control file data until the first explorer communicates to it, but the decision to allow real time control has to be taken before, the controller process peeks at the control file through a call to ``checkRealTimeControl()`` in :file:`main.cpp`. However, the actual input and output files used to interact with the user real time commands will not be created until the first explorer sends the data during the PELE MPI protocol initialization.

The global real time control option can be disabled through ``SystemVars::disableRealTimeControl()``. This makes sense in testing, where one test may need to have the option enabled, but the next one needs this disabled.

The command stream can be obtained through ``SystemVars::getCommandStream()``.

In summary, the global management of the option is done through:

.. code-block:: c++

  class SytemVars {
  public:
    // ...
    static bool allowsRealTimeControl();
    static void enableRealTimeControl(
	boost::shared_ptr<SimulationControlCommandStream> newCommandStream);
    static void disableRealTimeControl();
    static boost::shared_ptr<SimulationControlCommandStream> getCommandStream();
    // ...
  };

Commands and input/output
-------------------------

Commands are implemented in terms of ``SimulationControlCommand`` (in :file:`PELE/SimulationControl/SimulationControlCommand.h`), and the command stream (which controls both the input stream of commands, and the output where to write the replies), is implemented as the ``SimulationControlCommandStream``.

Only the controller creates the stream. The explorers limit themselves to communicate the controller the paths of the input/output files (the first explorer does so), and to enable real time control.

Controller
----------

Only the MPI controller is special (since the serial version is not yet allowed for real time control). When real time control is enabled, the ``MpiRealTimeControlExplorationController`` controller has to be used.

State communicator
------------------

Dealing with jumping and dealing with real time control commands is, fortunately, orthogonal, so different policies can be applied for both features. Policies for jumping must implement ``JumpProcessor``, while policies for real time control implement ``CommandProcessor`` (see :file:`PELE/PeleTasks/StateCommunicators/`). The ``StateCommunicator`` class implements both interfaces, and it actually redirects to the actual policy object received for each case, since both policies are injected during construction. Therefore, it is possible to construct:

- An MPI state communicator that allows real time control only.
- An MPI state communicator that allows jumping only.
- An MPI state communicator that allows real time control and jumping.
- A state communicator that does not allow neither jumping nor real time control (this one is useful for tests, and also for speeding up simulation if no jumping is allowed and no real time control is needed).

Similarly happens for the serial case (though this is partially implemented). The different policies available are:

- ``NullCommandProcessor``
- ``NullJumpProcessor``
- ``SerialCommandProcessor``
- ``SerialJumpProcessor``
- ``MpiCommandProcessor``
- ``MpiJumpProcessor``

Creation of the actual ``StateCommunicator`` to use for a given task is actually performed by the ``StateCommunicatorBuilder``.

State machine
=============

When allowing real time control of commands, the simulation can be in one of two states:

- Running: in this case, at least one explorer is running. Commands are accepted and, as soon as one command is read, it is communicated to all active explorers. Once all explorers receive the command (it can be either a PAUSE or a TERMINATE), the application either ends (TERMINATE) or goes to the PAUSE state.
- PAUSE: in this state, the controller only accepts new commands. If a CHANGE_PARAMETERS is received, it is transmitted to all active explorers. If a TERMINATE, all explorers are also informed, and the application ends. If a RESUME, the controller goes again to the running state.

Notice that while in the running state, jumping events may be happening, and have to be processed. This however cannot happen during the ``PAUSE`` state. For further information, check section :ref:`sec-dev-mpiProtocol`.

Useful tools
============

To help testing the implementation, the Python script :file:`scripts/workingWithPELE/pelecommander.py` allows sending commands to a running PELE simulation.

First, you must launch the simulation. Then, you start :program:`pelecommander.py` from the same directory, providing the control file as the first argument, and then wait for it to detect the input/output command files. Once this happens, you will be prompted to send commands to the application.

An example session:

.. code-block:: console

  $ mpirun -np 2 PELE-1.5_mpi control.conf
  # in a different terminal
  $ python pelecommander.py control.conf
    Ready to contact through /home/jestrada/tmp/pelechangeable/vacuum/commands.txt and /home/jestrada/tmp/pelechangeable/vacuum/commandsOutput.txt
    Select option:
    1. TERMINATE EXECUTION
    2. PAUSE EXECUTION (to change parameters)
    3. quit this application
    Your choice? 2
    Waiting for reply...
    Read reply  1
    Simulation paused at 1@1:28
    The simulation is currently paused. Select option:
    1. TERMINATE EXECUTION
    2. RESUME EXECUTION
    3. CHANGE PARAMETERS
    4. quit this application
    Your choice? 3
    Enter the parameter changes to send. Finish with a new line with the text *ENDCHANGES*
    {"Pele::parameters": {"numberOfPeleSteps": 5}}  
    *ENDCHANGES*
    Change of parameters sent. Resuming execution.
    Select option:
    1. TERMINATE EXECUTION
    2. PAUSE EXECUTION (to change parameters)
    3. quit this application
    Your choice? 3
    Exiting this application...

As seen, the simulation was paused for the single active explorer at task 1, step 28 (about to start that step). Then, the numberOfPeleSteps parameter was changed, and the simulation resumed.

The contents of :file:`commands.txt` after the simulation are:

.. code-block:: console

    $ cat commands.txt 
    {"commandId": 1,
	"commandType": "PAUSE",
	"commandData": ""
    }
    *END
    {"commandId": 2,
	"commandType": "CHANGE_PARAMETERS",
	"commandData": "{\"Pele::parameters\": {\"numberOfPeleSteps\": 5}}"
    }
    *END
    {"commandId": 3,
	"commandType": "RESUME",
	"commandData": ""
    }
    *END

And the content of the output file:

.. code-block:: console

    $ cat commandsOutput.txt 
    {"commandId": 1, "output": "1@1:28"}
    *END

Tests
=====

There is a test implemented in ``TestMPI::testRealTimeControl()`` to be run with 2 processes, that starts a simulation that will run many steps, and then, after waiting a few seconds to make sure the command input/output files have been created, it sends a change of parameters to the application, changing the number of PELE steps to run, so that the applications ends earlier than initially programmed.

