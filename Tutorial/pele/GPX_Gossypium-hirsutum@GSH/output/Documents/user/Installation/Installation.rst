############################
Installation
############################

In this section we will install the next software:

    1) PELE++ (The main C++ source code)

    2) PELE Platform (Python features on top of the C++)


PELE++
+++++++++++++++++++++++++

External Requirements: OpenMPI

Send an e-mail to it@nostrumbiodiscovery.com if you are interested on receiving the commercial software.
After revision of your application, we will send you a form to fill in with your machine specifications.
Then, you will recieve the PELE (pele.zip) binary containing the licenses to run and a test case to check the installation.

Option 1 - Manual
=====================

Test PELE installation
``````````````````````````````

.. code-block:: bash

    unzip PELE-1.7.zip
    cd PELE-1.7/samples/aspirin
    chmod -R u+wrx .
    #mpirun must be in PATH
    mpirun -np 3 ../../bin/Pele_mpi control_file --license-directory ../../licenses

(You may have to set some environment variables by exporting LD_LIBRARY_PATH)

**If the error** ``what():  locale::facet::_S_create_c_locale name not valid`` arises please run the command below
and execute again

.. code-block:: bash

   export LC_ALL=C; unset LANGUAGE



Option 2 - Singularity
=========================

We have several ways available to run PELE from Singularity containers, this method is ideal for running on HPC systems.

If you are interested in learning more about it, please contact it@nostrumbiodiscovery.com.




PelePlatform
++++++++++++++

ExternalRequirements:

  - Academic Schrodinger
    

Installation:
   
  https://nostrumbiodiscovery.github.io/pele_platform/installation/index.html

Test PelePlatform installation
`````````````````````````````````

  https://nostrumbiodiscovery.github.io/pele_platform/installation/index.html#test-it-works


