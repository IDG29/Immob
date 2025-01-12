.. _sec-peleOutputInfo:

***********
Pele Output
***********

Report file
===========

Text file where the Sensors (metrics and tracked variables) values are stored. The first data line corresponds to the initial state (marked with a value of 0 for both Step and AcceptedSteps). Then, there is a data line per accepted step (both Step and AcceptedSteps start counting at 1).

To configure path and filename see `reportPath <PELE/PeleOutput.html#reportpath>`_.

In multicore runs, a report file is generated for each browser (with a suffix number).

Example:
    
.. code-block:: text

	#Task    Step    numberOfAcceptedPeleSteps    currentEnergy    Binding Energy    sasaLig    distance
	1    0    0    -16102.1    -22.254    0.415516    4.6652    
	1    1    1    -19365.8    -11.5598    0.649762    7.74731    
	1    2    2    -19408.9    -6.45269    0.831063    10.4285    
	1    3    3    -19436.8    -7.41441    0.738071    11.3591    
	1    4    4    -19454.6    -2.23691    0.815661    10.4208    
	1    5    5    -19489.9    -13.5019    0.709215    10.3476


Trajectory file
===============

Pdb file where all the accepted models are saved to form a trajectory:

* Model 1 always corresponds to the initial state.
* Model 2 corresponds to the first recorded accepted step (see `saveFrequencyForAcceptedSteps <PELE/PeleOutput.html#savingfrequencyforacceptedsteps>`_).
* Model 3 to the second recorded accepted step, and so on.


It’s only used in **savingTrajectory** and **savingBoth**  `saving mode <PELE/PeleOutput.html#savingmode>`_ options.

To configure path and filename see `trajectoryPath <PELE/PeleOutput.html#trajectorypath>`_.

In multicore runs, a trajectory file is generated for each browser (with a suffix number).


Steps folder
============

Folder where all the accepted models are saved in separated pdb files. The file numbered as 0 is the initial state. For all other files, the number is the accepted step (thus, n corresponds to the nth accepted step; if `saveFrequencyForAcceptedSteps <PELE/PeleOutput.html#savingfrequencyforacceptedsteps>`_) is 2, the values for n will be 2, 4, 6, etc.).

It’s only used in **savingSteps** and **savingBoth**  `saving mode <PELE/PeleOutput.html#savingmode>`_  options.

To configure folder path see `stepsFolder <PELE/PeleOutput.html#stepsfolder>`_.