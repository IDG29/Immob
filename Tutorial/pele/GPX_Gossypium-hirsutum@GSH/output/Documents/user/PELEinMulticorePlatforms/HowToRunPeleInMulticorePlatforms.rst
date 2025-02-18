**************************************
How to run PELE in multicore platforms
**************************************

PELE can take advantage of multicore platforms in different ways:

-  OpenMP
-  MPI
-  MPI + OpenMP
-  CUDA (Experimental)

Brief introduction of computing language used in this page:

-  Processor: a die with one or more cores
-  Core: execution unit
-  Thread: process running in a core

Usually the meaning of each words depends on the context. It's also used
processor instead of core, etc.

OpenMP
======

In OpenMP, all the processors are sharing the memory of the system.
OpenMP allows us to use the multiple cores that are available in the
processor/s of our workstation in an easy and fast way. The OpenMP PELE
implementation is like the serial execution of PELE (one explorer) but
faster, doing some calculations in parallel.

To use the OpenMP version of PELE, you have to follow the next steps:

1. Compile PELE with the pre-processor flag -DOPENMP and the flags to compile an OpenMP source code in your machine.
2. Before run PELE, set the enviromental variable "OMP_NUM_THREADS" to set the number of threads that you want to use.

  .. code-block:: console

    $ setenv OMP_NUM_THREADS 4
    # or
    $ export OMP_NUM_THREADS=4

Tip: set at maximum the number of REAL cores that you have to map each thread to a real core and get the maximum perfomance. Pay attention if you have an Intel cpu with hyperthreading enable.

3. Run PELE

It doesn't need any anotation in the configuration file.

MPI
===

MPI allows us to communicate different processors that are not sharing
memory. We can also use MPI to comunicate the different cores or
processors that are sharing memory. MPI it's very used in supercomputers
The MPI implementation runs one explorer per thread. Is like a lot of
serial executions of PELE running at the same time being handled by a
controller. If we have N cores and we launch PELE using all of them, we
will have N-1 explorers and 1 controller.

1. Compile PELE for MPI
2. Set in the PeleParameters section of the configuration file the "useMPI" option to true.
3. Launch PELE using mpirun

  .. code-block:: console

     $ mpirun -np <numberOfProcessors> PELE <configurationFile>

If mpirun can't find some files and crash, set the "working directory",
in our case the Pele directory, adding the flag "-wd ".

If you are using Intel MPI and your execution fails with a message similar to:

.. code-block:: text

    Fatal error in MPI_Recv: Other MPI error, error stack:
    MPI_Recv(224)...................: MPI_Recv(buf=0x29598b0, count=13647, MPI_DOUBLE, src=3, tag=6, MPI_COMM_WORLD, status=0x1) failed
    PMPIDI_CH3I_Progress(623).......: fail failed
    pkt_RTS_handler(317)............: fail failed
    do_cts(662).....................: fail failed
    MPID_nem_lmt_dcp_start_recv(302): fail failed
    dcp_recv(165)...................: Internal MPI error!  Cannot read from remote process
     Two workarounds have been identified for this issue:
     1) Enable ptrace for non-root users with:
        echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
     2) Or, use:
        I_MPI_SHM_LMT=shm

try the second suggested option, by setting the environment variable ``I_MPI_SHM_LMT``:

.. code-block:: bash

  export set I_MPI_SHM_LMT=shm


MPI + OpenMP
============

It combines the two previous methods. In brief, the combination of
both technologies permit to have fastest explorers running at the same
time.

For example, if we have 10 processors with 4 cores each one, we can
have two configurations to use all the resources in an efficient way:

-  10 MPI threads (explorers) with 4 OpenMP threads
-  20 MPI threads (explorers) with 2 OpenMP threads

Tips
----

1. Don't split an explorer to use OpenMP threads from a different
   processors. This situation can decrease the performance. Example, if
   we have 2 processors sharing memory with 6-core each, we have the
   following good and bad configurations:

    -  2 MPI threads with 6 OpenMP threads -> GOOD
    -  3 MPI threads with 4 OpenMP threads -> BAD, because one MPI
       thread will have 2 OpenMP thread in one processors and 2 OpenMP
       thread in other processor
    -  4 MPI threads with 3 OpenMP threads -> GOOD
    -  6 MPI threads with 2 OpenMP threads -> GOOD

CUDA (Experimental)
===================

It's very hardware dependent. Use OpenMP and MPI.

