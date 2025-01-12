.. _sec-dev-buildSystem:

************
Build system
************

Dependencies
============

The PELE software depends on the following:

- Python 2.7 for the scripts (https://www.python.org).
- Schrödinger software suite for some of the scripts (such as :program:`PlopRotTemp.py`) https://www.schrodinger.com/
- Boost 1.71 (http://www.boost.org)
- Jsoncpp 0.10.6 (https://github.com/open-source-parsers/jsoncpp). Needs version g++<6.9
- Crypto++ 5.6.5 (https://www.cryptopp.com/). When using standard licensing library (-DUSE_LCC=OFF)
- Licensecc (https://github.com/open-license-manager/licensecc). When using LCC as licensing library (-DUSE_LCC=ON)
- Wjelement https://github.com/netmail-open/wjelement (uses an inhouse version, in https://svn.bsc.es/repos/pele/libraries/external/wjelement)
- BLAS and LAPACK.
- OpenMPI 1.6+ (it can probably work with other MPI implementations, such as the one by Intel) https://www.open-mpi.org/
- Some experimental parts depend on OpenMP (http://www.openmp.org/), CUDA (http://www.nvidia.com/object/cuda_home_new.html) and OpenCL (https://www.khronos.org/opencl/).

Besides, for the building and deployment, it is needed:

- CMake 3.5.2+ (https://cmake.org/)
- g++/gcc/gfortran 4.4.7+ (or similar Intel compiler, working with C++03) https://gcc.gnu.org.
- patchelf 0.9 and chrpath (for building the redistributable binaries) https://nixos.org/patchelf.html .
- Subversion 1.8+ (to access to the source code) https://subversion.apache.org/
- PySVN (used in scripts to build and deploy the software) http://pysvn.tigris.org/
- Fabric 1.13.2: For deploying the software (http://www.fabfile.org/).
- Nose 1.3.7: For running Python tests (http://nose.readthedocs.io/en/latest/).
- Sphinx 1.6.1: To build the documentation (http://www.sphinx-doc.org).
- watchdog 0.8.3: For :program:`pelecommander.py`, when testing the real-time control of PELE (https://github.com/gorakhargosh/watchdog).

It's also necessary to edit the licensecc_properties.h file from the corresponding project to increase the size of 2 variables:

 - LCC_API_PROPRIETARY_DATA_SIZE 50
 - LCC_API_FEATURE_NAME_SIZE 50

Build Flags
===========

At the moment there are several flags that can be set, depending on which executable you want to build.

*FLAG_NAME (DEFAULT_VALUE)*

- **BUILD_REDISTRIBUTABLE (OFF)**: Build for redistribution (uses RPATH, avoids some machine-specific optimizations).
- **DEBUG (OFF)**: Compile for debugging.
- **PRODUCTION (OFF)**: Compile the production version. If production version is enabled, subprocesses will not print anything in command console, because cout will be set to failbit.
- **RUN_LONG_TESTS (OFF)**: Compile the version that includes lengthy nightly tests".
- **USE_MPI (OFF)**: Compile for MPI execution.
- **USE_CUDA (OFF)**: Compile for CUDA devices.
- **USE_OPENCL (OFF)**: Compile for OpenCL devices.
- **USE_OPENMP (OFF)**: Uses OpenMP function implementations.
- **USE_OPENMP_PERTURBATION (OFF)**: Use OpenMP implementation of perturbation. Activate USE_OPENMP in order to enable this too.
- **PROFILE (OFF)**: Build for profiling.
- **USE_MKL (OFF)**: Use the Intel MKL mathematical libraries.
- **USE_GCC_OLD_CPLUSPLUS_ABI (OFF)**: Use the old GCC C++ ABI. This option is only valid when compiling with the GCC compiler.



Reference development (and testing) machine
===========================================

The reference build machine is an Ubuntu precise (12.04.5 LTS; vagrant box ubunto/precise64 version 20170427.0.0 for virtualbox). To build PELE and run the tests on that machine, you need to setup this. You can do so with vagrant (https://www.vagrantup.com) using VirtualBox (https://www.virtualbox.org/), which allows to setup and configure a virtual machine running the given operating system; this machine has been set up with Vagrant 1.9.1 and using VirtualBox 5.1.

You will need the following directory structure:

.. code-block:: console

  pele-base/
     Vagrantfile
     devel_requirements.txt
     provision.sh
     peleLicense.txt
     peleLicense.txt.digest
  PELE-1.5/
  wjelement/

Your vagrant working directory will be :file:`pele-base/`, and you will have working copies of the ``PELE-1.5`` and ``wjelement`` projects under the given diretories. These directories will later be shared from the vagrant virtual machine.

The configuration file :file:`Vagrantfile`, the :file:`devel_requirements.txt` file (for the Python virtual environment requirements) and the provisioning file :file:`provision.sh` can be obtained from :file:`scripts/vagrant/` in the ``PELE-1.5`` working copy. The license files are needed to run the tests. To get working copies of PELE and wjelement, from the top directory, run:

.. code-block:: console

  $ svn co https://svn.bsc.es/repos/pele/PELE-1.5
  $ svn co https://svn.bsc.es/repos/pele/libraries/external/wjelement

To configure the virtual machine, go to :file:`pele-base/` and run ``vagrant up``:

.. code-block:: console

  $ cd pele-base
  $ vagrant up

The setup will follow the :file:`Vagrantfile`, which is configured to download the virtual machine image from the official Ubuntu (https://atlas.hashicorp.com/ubuntu/boxes/precise64), and then run the provisioning script :file:`provision.sh`. Notice that the setup script also shares the :file:`PELE-1.5` and :file:`wjelement` folders as :file:`/home/vagrant/sf_workspace/PELE-1.5` and :file:`/home/vagrant/sf_workspace/wjelement` respectively. It will also shared the :file:`pele-base/` directory as :file:`/vagrant/`. For the building and the testing to work, the virtual machine needs, at least, 2 GB of memory (also configured in this file).

Alternatively, you can grab a pre-built machine from the shared repository of vagrant machines, and use as :file:`Vagrantfile` the file :file:`scripts/vagrant/Vagrantfile-prebuilt` (you have to rename it first). For example:

.. code-block:: console

  $ vagrant box add /path/to/machine/repo/pele-base20170620.box --name eapmbsc/pele-base
  $ cd pele-base
  $ cp ../PELE-1.5/scripts/vagrant/Vagrantfile-prebuilt Vagrantfile
  $ vagrant up

Whether you use the prebuilt machine or you build it from the ground, you should get to the same virtual machine.

As a summary of shared directories:

- :file:`PELE-1.5` as :file:`/home/vagrant/sf_workspace/PELE-1.5/`.
- :file:`wjelement` as :file:`/home/vagrant/sf_workspace/wjelement/`.
- :file:`pele-base` as :file:`/vagrant/`.

The setup will create the following directory structure under :file:`/home/vagrant/`:

- :file:`bin/`: local binaries, such as :file:`patchelf`.
- :file:`share/`: local shared data, such as the one used by :file:`patchelf`.
- :file:`builds/`: for creating the CMake directories used for building.
- :file:`opt/`: for writing the final layout of a PELE distribution, before packaging.
- :file:`PELEdependencies/`: to keep the external dependencies used by PELE (such as OpenMPI and wjelement).
- :file:`sf_workspace/`: directories shared with the host machine.
- :file:`software/`: to store downloaded software for compilation.
- :file:`.virtualenvs/pele`: the Python virtual environment with the required packages to work in development of PELE.

The versions of the main software needed for development are:

- kernel: 3.2.0-126-virtual #169-Ubuntu SMP x86_64 GNU/Linux
- glibc: Ubuntu EGLIBC 2.15-0ubuntu10.18
- g++/gfortran: Ubuntu/Linaro 4.6.3-1ubuntu5
- python: 2.7.3
- boost: 1.48.0.2
- CMake: 2.8.7
- OpenMPI: 1.8.1 (sistema: 1.4.3-2.1ubuntu3)
- JsonCPP: 0.10.6
- Crypto++: 5.6.1-5build1
- svn: 1.6.17

Regarding the virtual environment of PELE, the packages are:

- pysvn 1.7.10 (for deployment)
- Fabric 1.13.2 (for deployment)
- Sphinx 1.6.1 (for the documentation)
- nose 1.3.7 (for testing)
- enum34 1.1.6 (for pelecommander.py)
- watchdog 0.8.3 (for pelecommander.py)

Once the setup is done, the machine starts running, and you can connect using (from :file:`pele-base/`):

.. code-block:: console

  $ vagrant ssh
  vagrant@vagrant-ubuntu-precise-64:~$

If you need to use Python (for example, for running the Python tests), you first need to activate the virtual environment; finally, you need to deactivate it:

.. code-block:: console

  vagrant@vagrant-ubuntu-precise-64:~$ source ~/.virtualenvs/pele/bin/activate
  # do some work
  vagrant@vagrant-ubuntu-precise-64:~$ deactivate

Once you finish execution and you exit from the machine, you can halt the machine with (also from :file:`pele-base/`):

.. code-block:: console

  $ vagrant halt

To restart the machine, from :file:`pele-base/`, run:

.. code-block:: console

  $ vagrant up

You can learn more about Vagrant at https://www.vagrantup.com/docs/

To build the binaries for the tests, you can use the :file:`/home/vagrant/builds/` directory. First, you will need to build and install wjelement:

.. code-block:: console

  $ mkdir /home/vagrant/builds/wjelementbuild
  $ cd /home/vagrant/builds/wjelementbuild
  $ cmake ~/sf_workspace/wjelement -DCMAKE_INSTALL_PREFIX:PATH=/home/vagrant/PELEdependencies/wjelement -DSTATIC_LIB=yes
  $ make
  $ make install

This will install wjelement under :file:`/home/vagrant/PELEdependencies/wjelement`.

Then, for example, for building the serial version:

.. code-block:: console

  $ cd /home/vagrant/builds
  $ mkdir pelebuild
  $ cd pelebuild
  $ cmake -C ~/sf_workspace/PELE-1.5/cmakeconfigs/standard.cmake ~/sf_workspace/PELE-1.5 -DUSE_MPI=OFF -DPRODUCTION=OFF -DBUILD_REDISTRIBUTABLE=OFF
  $ make -j 2

Notice that the previous command uses the configuration of :file:`standard.cmake`, which uses a different OpenMPI version than the one installed by default in ubuntu Precise (and which the provisioning script installs at :file:`/home/vagrant/PELEdependencies/openmpi-1.8.1/`). If you want to use a different version of OpenMPI, you can download and install it, and then use a different CMake configuration file to instruct CMake where to find it. Notice that, when executing the MPI version, you will need to setup the ``PATH`` and ``LD_LIBRARY_PATH`` environment libraries so that the execution can find the right binaries and libraries.

You will find more information on building and executing the tests for the different versions at :ref:`sec-dev-tests`.

Building in Marenostrum IV
==========================

To build in Marenostrum IV, you will use the Intel compilers, and you need the following environment (check :file:`scripts/Production/BuildSetup/runInBuildEnvMarenostrumIV.sh`, since that is the configuration file used for automatic building):

.. code-block:: console

  module purge
  module load intel mkl impi python/2.7.13 boost/1.64.0_py2 bsc cmake
  unset CFLAGS
  unset CPPFLAGS
  unset CXXFLAGS
  unset FCFLAGS

Besides, all dependencies will be installed under :file:`/gpfs/projects/bsc72/PeleDevelopment/mniv/`, except for Boost, which comes preinstalled at :file:`/apps/BOOST/1.64.0_py2/INTEL/IMPI/`. Therefore, the paths for the dependencies (check :file:`cmakeconfigs/marenostrumiv.cmake`) are:

- Wjelement: :file:`/gpfs/projects/bsc72/PeleDevelopment/mniv/wjelement/rev12146/INTEL/`.
- Crypto++: :file:`/gpfs/projects/bsc72/PeleDevelopment/mniv/cryptopp/5.6.5/INTEL/`.
- Jsoncpp: :file:`/gpfs/projects/bsc72/PeleDevelopment/mniv/jsoncpp/0.10.6/INTEL/`.

You will also use special optimization flags: ``-mtune=skylake -xCORE-AVX512 -m64``, that appear codified with the ``NATIVE_OPTIMIZATION_FLAGS`` variable in the CMake configuration file.

To build the dependencies:

For Crypto++:

.. code-block:: console

  $ mkdir -p ~/software/mniv/intel/cryptopp565
  $ cd ~/software/mniv/intel/cryptopp565
  $ unzip /path/to/cryptopp565.zip
  $ make
  # Check the compilation succeeded
  $ ./cryptest.exe v
  $ ./cryptest.exe tv all
  $ make install PREFIX=/gpfs/projects/bsc72/PeleDevelopment/mniv/cryptopp/5.6.5/INTEL

For Jsconcpp (you need version 0.10.6, which comes with a CMake build system):

.. code-block:: console

  $ cd ~/software/mniv/intel/
  $ tar xf /path/to/jsoncpp-0.10.6.tar.gz
  $ cd jsoncpp-0.10.6
  $ mkdir build
  $ cmake .. -DCMAKE_BUILD_TYPE=Release -DBUILD_STATIC_LIBS=ON -DBUILD_SHARED_LIBS=OFF -DCMAKE_INSTALL_PREFIX=/gpfs/projects/bsc72/PeleDevelopment/mniv/jsoncpp/0.10.6/INTEL
  $ make
  # Check the output of make shows that all tests passed
  $ make install

For the Wjelement version included with PELE (in this example, it corresponds to rev. 12479):

.. code-block:: console

  $ cd /path/to/wjelement
  $ mkdir buildINTEL
  $ cd buildINTEL
  $ CFLAGS="-mtune=skylake -xCORE-AVX512 -m64 -fPIC" cmake .. -DCMAKE_INSTALL_PREFIX:PATH=/gpfs/projects/bsc72/PeleDevelopment/mniv/wjelement/rev12479/INTEL -DSTATIC_LIB=yes
  $ make
  $ make install 

.. note::

  If installing in Marenostrum IV with GCC, you will need to build JsonCPP and Crypto++ using the old GCC C++ ABI (see https://gcc.gnu.org/onlinedocs/libstdc++/manual/using_dual_abi.html). In such a case, you will build Crypto++ as follows:

  .. code-block:: console

    $ make CXXFLAGS="-D_GLIBCXX_USE_CXX11_ABI=0 -DNDEBUG -g2 -O2 -fPIC -march=native -pipe" PREFIX=/gpfs/projects/bsc72/PeleDevelopment/mniv/cryptopp/5.6.5/GCCABI0
    # Check the compilation succeeded
    $ ./cryptest.exe v
    $ ./cryptest.exe tv all
    $ make install PREFIX=/gpfs/projects/bsc72/PeleDevelopment/mniv/cryptopp/5.6.5/GCCABI0

  For more information on building Crypto++, see https://www.cryptopp.com/wiki/Compiling and https://www.cryptopp.com/wiki/Linux#Build_and_Install_the_Library

  And for JsonCPP, you will do the following change in its SConstruct file:

  .. code-block:: console
 
    $ diff SConstruct SConstruct.original
    122c122
    <     env.Append( LIBS = ['pthread'], CCFLAGS = "-Wall", CPPFLAGS="-D_GLIBCXX_USE_CXX11_ABI=0")
    ---
    >     env.Append( LIBS = ['pthread'], CCFLAGS = "-Wall -D_GLIBCXX_USE_CXX11_ABI=0" )

With all the dependencies installed, deployment of the actual Marenostrum IV binaries is done through the Fabric system, using the :file:`scripts/Production/fabfile.py` script. Notice that, if building the binaries manually, you will:

- Use the :file:`scripts/Production/createProductinCode.py` script to package the source code and related files.
- Build using CMake, with the configuration file :file:`cmakeconfigs/marenostrumiv.cmake`, and the additional flags ``-DUSE_MKL``.

Building in Nord III
====================

To build in Nord III, you will use the GCC compilers, and you need the following environment (check :file:`scripts/Production/BuildSetup/runInBuildEnvNordIII.sh`, since that is the configuration file used for automatic building):

.. code-block:: console

  module purge
  module load gcc cmake openmpi transfer bsc
  unset CFLAGS
  unset CPPFLAGS
  unset CXXFLAGS
  unset FCFLAGS

Besides, all dependencies will be installed under :file:`/gpfs/projects/bsc72/PeleDevelopment/nord/`, except for Boost, which comes preinstalled at :file:`/apps/BOOST/1_52_0/`, and the BLAS/LAPACK libraries which are installed under :file:`/gpfs/projects/bsc72/PeleDevelopment/nord/lib/`. Therefore, the paths for the dependencies (check :file:`cmakeconfigs/nord.cmake`) are:

- Wjelement: :file:`/gpfs/projects/bsc72/PeleDevelopment/nord/wjelement/rev12146/GCC/`.
- Crypto++: :file:`/gpfs/projects/bsc72/PeleDevelopment/nord/cryptopp/5.6.5/GCC/`.
- Jsoncpp: :file:`/gpfs/projects/bsc72/PeleDevelopment/nord/jsoncpp/0.10.6/GCC/`.

To build the dependencies:

For Crypto++:

.. code-block:: console

  $ mkdir -p ~/software/nord/gcc/cryptopp565
  $ cd ~/software/nord/gcc/cryptopp565
  $ unzip /path/to/cryptopp565.zip
  $ make
  # Check the compilation succeeded
  $ ./cryptest.exe v
  $ ./cryptest.exe tv all
  $ make install PREFIX=/gpfs/projects/bsc72/PeleDevelopment/nord/cryptopp/5.6.5/GCC

For Jsconcpp (you need version 0.10.6, which comes with a CMake build system):

.. code-block:: console

  $ cd ~/software/nord/gcc/
  $ tar xf /path/to/jsoncpp-0.10.6.tar.gz
  $ cd jsoncpp-0.10.6
  $ mkdir build
  $ cmake .. -DCMAKE_BUILD_TYPE=Release -DBUILD_STATIC_LIBS=ON -DBUILD_SHARED_LIBS=OFF -DCMAKE_INSTALL_PREFIX=/gpfs/projects/bsc72/PeleDevelopment/nord/jsoncpp/0.10.6/GCC
  $ make
  # Check the output of make shows that all tests passed
  $ make install

For the Wjelement version included with PELE (in this example, it corresponds to rev. 12479):

.. code-block:: console

  $ cd /path/to/wjelement
  $ mkdir buildGCC
  $ cd buildGCC
  $ cmake .. -DCMAKE_INSTALL_PREFIX:PATH=/gpfs/projects/bsc72/PeleDevelopment/nord/wjelement/rev12479/GCC -DSTATIC_LIB=yes 
  $ make
  $ make install

With all the dependencies installed, deployment of the actual Nord III binaries is done through the Fabric system, using the :file:`scripts/Production/fabfile.py` script.

Building in the Life cluster
============================

To build in the Life cluster, you will use the GCC compilers. You do not need to setup any special environment.

Besides, all dependencies will be installed under :file:`/data/EAPM/PELE/PELE++/apps/`, except for Boost, which comes preinstalled in the system directories, and the BLAS/LAPACK libraries which are installed under :file:`/data/EAPM/PELE/PELE++/shared/`. Therefore, the paths for the dependencies (check :file:`cmakeconfigs/life.cmake`) are:

- Wjelement: :file:`/data/EAPM/PELE/PELE++/apps/WJELEMENT/rev12146/GCC/`.
- Crypto++: :file:`/data/EAPM/PELE/PELE++/apps/CRYPTOPP/5.6.5/GCC/`.
- Jsoncpp: :file:`/data/EAPM/PELE/PELE++/apps/JSONCPP/0.10.6/GCC/`.

To build the dependencies:

For Crypto++:

.. code-block:: console

  $ mkdir -p ~/software/cryptopp565
  $ cd ~/software/cryptopp565
  $ unzip /path/to/cryptopp565.zip
  $ make
  # Check the compilation succeeded
  $ ./cryptest.exe v
  $ ./cryptest.exe tv all
  $ make install PREFIX=/data/EAPM/PELE/PELE++/apps/CRYPTOPP/5.6.5/GCC

For Jsconcpp (you need version 0.10.6, which comes with a CMake build system):

.. code-block:: console

  $ cd ~/software
  $ tar xf /path/to/jsoncpp-0.10.6.tar.gz
  $ cd jsoncpp-0.10.6
  $ mkdir build
  $ cmake .. -DCMAKE_BUILD_TYPE=Release -DBUILD_STATIC_LIBS=ON -DBUILD_SHARED_LIBS=OFF -DCMAKE_INSTALL_PREFIX=/data/EAPM/PELE/PELE++/apps/JSONCPP/0.10.6/GCC
  $ make
  # Check the output of make shows that all tests passed
  $ make install

For the Wjelement version included with PELE (in this example, it corresponds to rev. 12479):

.. code-block:: console

  $ cd /path/to/wjelement
  $ mkdir build
  $ cd build
  $ cmake .. -DCMAKE_INSTALL_PREFIX:PATH=/data/EAPM/PELE/PELE++/apps/WJELEMENT/rev12479/GCC -DSTATIC_LIB=yes
  $ make
  $ make install

With all the dependencies installed, deployment of the actual Life binaries is done through the Fabric system, using the :file:`scripts/Production/fabfile.py` script.

Building the redistributable binary
===================================

To build the redistributable binary, you need the reference development virtual machine (see previous section). Start the machine, if is not yet started; then connect to it, set up the Python environment, create the distribution directory, and run the script that creates the distribution. Later, you can copy this file to a shared folder (such as :file:`/vagrant/`), so that you can copy it somewhere else.

.. code-block:: console

  # start the machine if not yet running
  $ vagrant up
  $ vagrant ssh
  vagrant@vagrant-ubuntu-precise-64:~$ source ~/.virtualenvs/pele/bin/activate
  (pele) vagrant@vagrant-ubuntu-precise-64:~$ cd builds
  (pele) vagrant@vagrant-ubuntu-precise-64:~$ mkdir peledist
  (pele) vagrant@vagrant-ubuntu-precise-64:~$ cd peledist
  (pele) vagrant@vagrant-ubuntu-precise-64:~$ python ~/sf_workspace/PELE-1.5/scripts/Production/createDist.py ~/sf_workspace/PELE-1.5
  (pele) vagrant@vagrant-ubuntu-precise-64:~$ cp dist/PELErevXXX.tgz /vagrant
  # exit from the Python virtual environment
  (pele) vagrant@vagrant-ubuntu-precise-64:~$ deactivate
  vagrant@vagrant-ubuntu-precise-64:~$ exit
  # halt the virtual machine once you are done
  $ vagrant halt

In the previous commands, ``revXXX`` is the exact revision built. Notice the redistributable will work under any system with a configuration similar to the one of the virtual machine, that is:

- kernel: 3.2.0+
- glibc: 2.15+
- OpenMPI: 1.8.x

If you need a different configuration, you will need to modify the :file:`standard.cmake` CMake configuration file, so that it finds the right OpenMPI version, or you will have to prepare a different virtual machine, with different versions of the kernel and glibc library.

For example, there is an alternative build machine, a CentOS 6.8 one, that can be configured with :file:`scripts/vagrant/Vagrantfile-centos` and the provisioning of :file:`scripts/vagrant/provision-centos.sh`. The :program:`createDist.py` is already prepared to be able to run in this machine, using the CMake configuration file :file:`centos.cmake`. This CentOS machine is configured for:

- kernel: 2.6.32+
- glbic: 2.12+
- OpenMPI: 1.10.2

Once you have the distribution, you can test it as follows. We will assume you have revision 12407. You will need:

- The distribution package PELErev12407.tgz.
- The license files (peleLicense.txt and peleLicense.txt.digest).

.. code-block:: console

  # Untar the package
  $ tar xf PELErev12407.tgz
  # Copy the licenses
  $ mkdir -p PELErev12407/licenses
  $ cp /path/to/licenses/peleLicense.* PELErev12407/licenses
  # Go to the tests directory
  $ cd PELErev12407/samples/aspirin
  # Create the results directory, and link to Data and Documents
  # You will need to add write permissions to the aspirin folder
  $ chmod u+w .
  $ mkdir results
  $ ln -s ../../Data Data
  $ ln -s ../../Documents Documents
  # And finally, edit the control_file so that it points to the licenses directory
  # You may need to add write permission to the file (chmod u+x control_file).
  # Alternatively, you can provide the license directory as follows:
  $ ../../bin/PELE-1.5_serial control_file --license-directory ../../licenses
  and for the MPI version
  $ mpirun -np 3 ../../bin/PELE-1.5_mpi control_file --license-directory ../../licenses


Distributing the sources
========================
To distribute PELE, you need both the PELE sources (which include YaleMode), as well as the modified wjelement library.

Notice that the distributed sources will only include the production code, and not the test code.

To obtain both sources, you need access to the version control repository, and you need a working copy of the PELE-1.5 repository. You also need sphinx-doc installed in your system to run some of the scripts. Then:

.. code-block:: console

  $ python scripts/Production/createProductionCode.py <PELE-working-directory> myPELEproductionSource
  $ tar czf myPELEproductionSource.tgz myPELEproductionSource
  $ svn export https://svn.bsc.es/repos/pele/libraries/external/wjelement wjelement-pele
  $ tar czf wjelement-pele.tgz wjelement-pele
  # Now, you can remove the source directories
  $ rm -rf myPELEproductionSource
  $ rm -rf wjelement-pele

You will end up with :file:`myPELEproductionSource.tgz` and :file:`wjelement-pele.tgz` containing all the sources you need.

A suggested structure for the source compilation is:

.. code-block:: text

  PELEdist/
      PELE-src/
      wjelement-pele/
      licenses/
      PELE-User-Guide/
      samples/

and a suggested structure for the installation is:

.. code-block:: text

  /opt/PELE/
          vXXX/
              bin/
	      Documents/
	      Data/
          licenses/
          PELEdependencies/
	  samples/

To build the system, run:

.. code-block:: console

  $ cd PELEdist/wjelement-pele
  $ mkdir build
  $ cd build
  $ cmake .. -DCMAKE_INSTALL_PREFIX:PATH=/opt/PELE/PELEdependencies/wjelement -DSTATIC_LIB=yes
  $ cd PELEdist/PELE-src
  # Now, configure cmakeconfigs/<yourconfig>.cmake so that all paths of 
  # dependencies point to the right places
  $ mkdir build
  $ cd build
  $ cmake -C ../cmakeconfigs/<yourconfig>.cmake .. -DUSE_MPI=OFF -DPRODUCTION=ON
  $ cd ..
  $ mkdir buildMPI
  $ cd buildMPI
  $ cmake -C ../cmakeconfigs/<yourconfig>.cmake .. -DUSE_MPI=ON -DPRODUCTION=ON

Then, install the artifacts:

.. code-block:: console

  $ mkdir -p /opt/PELE
  $ mkdir -p /opt/PELE/vXXX
  $ mkdir -p /opt/PELE/vXXX/bin
  $ cp -r PELEdist/licenses /opt/PELE
  $ cp PELEdist/PELE-src/build/PELE-1.5 /opt/PELE/vXXX/bin/PELE-1.5
  $ cp PELEdist/PELE-src/build/PELE-1.5 /opt/PELE/vXXX/bin/PELE-1.5_mpi
  $ cp -r PELEdist/PELE-src/Documents /opt/PELE/vXXX
  $ cp -r PELEdist/PELE-src/Data /opt/PELE/vXXX
  $ cp -r PELEdist/PELE-User-Guide /opt/PELE/vXXX/Documents
  $ cp -r PELEdist/samples /opt/PELE/vXXX

Working with Eclipse
====================

The IDE of preference to develop PELE is Eclipse Luna Service Release 1 (4.4.1) for Parallel Application Developers, under a Linux environment (see http://wiki.eclipse.org/Eclipse/Installation#Eclipse_4.4_.28Luna.29). 

Eclipse is mainly used, for this project, to navigate the code and to review changes before committing them. At this time, the build system uses CMake from the command line. However, you may want to integrate the build system into Eclipse; for some pointers, see below.

To complete your Eclipse installation, you will need to install the following plugins:

- Eclipse C/C++ Development Tools (version 8.6.0.201502131403).
- Subclipse 1.10, to work with the PELE Subversion repository (http://subclipse.tigris.org/servlets/ProjectProcess?pageID=p4wYuA). This includes: Subversion Client Adapter 1.10.2, Subversion JavaHL 1.8.10, SVN Team Provider Core 1.10.6 and SVNKit Client Adapter 1.8.9. See the configuration section below for instructions on its installation.
- Eclipse EGit (4.0.1) http://eclipse.org/egit/, to work with other PELE-related repositories using Git.
- Eclipse PyDev 3.9.0, to work with Python scripts in the PELE source code.
- JSON Tools for Eclipse 1.0.4 (https://bitbucket.org/denmiroch/jsontools/src/default/JsonSite/).
- CMakeEd (http://downloads.sourceforge.net/project/cmakeed/eclipse/). You will need to add this URL to the list of software installation directories of Eclipse. To install it, go to ``Help > New software ...``. The project web site is http://cmakeed.sourceforge.net/

Basic Eclipse concepts
----------------------

Eclipse works with perspectives and views. Each perspective (such as the `C/C++` or the `Team Synchronizing` ones) offers a set of views to work. Each view lets you do a set of related tasks with your project; all views deal with tasks related by the common perspective the views belong to. For example, all `C/C++` views are related to programming in C/C++, traversing the code tree (in the `Project Explorer` view), navigating a source code file (in the `Outline` view), and the like.

Eclipse configuration
---------------------

You can change the color scheme by going to ``Window>Preferences>General>Appearance`` and choosing ``Theme: High Contrast`` and ``Color and Font theme: Classic Theme``. Then, under ``Colors and Fonts``, increase to 12pt the values for ``Basic-Text Editor Block Selection`` and ``Basic-Text Font``.

Subclipse
---------

To install Subclipse 1.10, since there is an error with the usage of the GNOME keyring.

For the plugin to work, you should use SVNKit 1.8.6. Under ``Window > Preferences > Team > SVN``, choose ``SVN interface: SVNKit (Pure Java)``.

Subclipse does not store passwords itself, but it delegates on SVNKit or JavaHL. If using SVNKit, passwords are stored at the Eclipse keyring (a file similar to :file:`/home/user/.eclipse/org.eclipse.platform_3.7.0_155965261/configuration/org.eclipse.core.runtime/.keyring` or under the installation directory, in a place such as :file:`/path/to/eclipse/configuration/org.eclipse.core.runtime/.keyring`. If using JavaHL, it is then stored according to Subversion rules, which are configured under :file:`~/.subversion/servers` and :file:`~/.subversion/config`.

To configure Eclipse's keyring, go to ``General > Security > Secure Storage``. Notice that, apparently, Eclipse does not use any encryption key for the :file:`.keyring` file. See http://help.eclipse.org/kepler/index.jsp?topic=%252Forg.eclipse.rse.doc.user%252Ftasks%252Ftbeginpass.html and https://vanappdeveloper.com/2013/01/13/recovering-eclipse-zendstudio-saved-remote-passwords/ 

To configure and use the version control plugin:

- To configure the project repository (needed before doing any other step): Open the `SVN Repository Exploring` perspective and, in the `SVN Repositories` view, right click and select `New -> Repository location ...`. Enter the connection details: project repository URL, user and password.
- To create a working copy of the project, select the project from the `SVN Repositories` view, and right click `Checkout`. Select `Check out as a project in the workspace` (this will place the project in your Eclipse workspace). 
- To update your working copy of the project to the latest version in the repository, in the `C/C++` perspective, in the `Project Explorer` view, right click on the project name and select `Team -> Update to HEAD`.
- To check differences between your working copy and the repository, open the `Team Synchronizing` perspective (you can do so by right clicking in your project in the `Project Explorer` view, and then select `Team -> Synchronize with Repository`. You will be able to see all outgoing changes (those changes you did that are not in the repository) and the incoming changes (those changes in the repository not in your working copy); for that, click on the `Incoming/Outgoing mode` in the button row of the `Synchronize` view.


Using Egit
----------

Check the user guide at http://wiki.eclipse.org/EGit/User_Guide

To see the changes done against the previous commit, do from the contextual menu ``Compare With > HEAD revision``. If checking agains the Git index, do ``Compare With > Git index``.

For comparison with a branch, whether local or remote, use ``Team > Synchronize``.

Github flow
----------

The following gidelies are a propostal to stablish a common github flow when working with PELE-repo.

* Common branches:
    -``master``
    
    -``develop``
    
* Branch types:
    -``V*.*.*-feature-*``: Example V1.7.2-feature-ANMWithoutProtein
    
    -``V*.*.*-hotfix-*``: Example V1.7.2-hotfix-TestVacuum

* Rules:
    1. Anything in `master` is deployable.
    2. `master` only gets new commits by:
        - A merge commit from develop
        - A `hotfix` branch if is urgent
    3. Every new commit in `master` gets a version tag.
    4. Pull requests can be opened at any time.
    5. Pull requests merges should be accepted only after revision.
    
* Pull request process:
    - Open pull request freely.
    - The smaller the better.
    - Provide description with changes made, and some explanation.
    - Review as soon as possible.
    - Merge once all tests are passing.
    

Eclipse and CMake
-----------------

Some useful pointers for integration of the CMake build system used in PELE into Eclipse:

- CMake wiki: http://www.cmake.org/Wiki/CMake:Eclipse_UNIX_Tutorial
- A tutorial with Eclipse CDT4 Generator: https://www.johnlamp.net/cmake-tutorial-2-ide-integration.html
- A tutorial with the Unix Makefile Generator: http://johnnado.com/use-cmake-with-eclipse/
- Eclipse, CMake and C++11: http://marian.schedenig.name/2013/11/21/eclipse-cmake-and-c11/
- cmake4eclipse, to simplify project creation: http://marketplace.eclipse.org/content/cmake4eclipse

Main considerations are:

- CMake projects are ephimeral. If CMakeLists.txt changes too much, you have to remove the CMake related Eclipse project and recreate it.
- Eclipse typically works with a single build target per project, while CMake projects allow multiple targets.
- Eclipse allows working with different versions of the same target (such as *Release* and *Debug*). With CMake, this requires creating different projects.
- CMake is generally used for out-of-source builds. Eclipse, however, does not work in such a way.
- Eclipse needs the project configuration file to be at the root directory of the project, so that it can do version control with Subversion or Mercurial. This is not compatible with the way CMake works, so you will also need a separate project to hold PELE's source code.

To choose a target to compile, go to ``Window > Show View > Make Target``.

If you want to check the source code of your project straight from your CMake Eclipse project, you can go to ``[Source directory]``. The linking between build errors and the offending source code line does not seem to always work.

See all build warnings
----------------------

By default, only the first 100 compilation warnings are shown. To see more, go the the ``Problems``view, open the drop menu (next to the minimization icon), and choose ``Configure Contents ...``, removing the tick on ``Use item limits``.

Indexing of C/C++ code
----------------------

Indexing is very useful, since it allows you to jump straight from one function call to its definition, or to locate all usages of a given variable. To configure it, open the contextual menu in the *Project Explorer*  and choose ``Properties > C/C++ General > Indexer``, then pick ``Enable Project Specific settings, Store settings with projects, Enable indexer``, also choosing the indexing options ``Index source files not included in the build`` and ``Allow heuristic resolution of includes``.

You can check the indexing progress with ``Window > Show view > Progress``. Also, to see the complete index, go to the Index view: ``Window > Show view > Other > C/C++ > C/C++ Index``.

Editors associated to file extensions
-------------------------------------

Go to ``Windows > Preferences > General > Editors > File Associations``.

You can always open a given file with your editor of choice by selecting ``Open with > Other ...``.

Searches
--------

To skip some directories during the search, you can mark them as ``Derived``. This makes sense for build directories such as those of CMake (``buildRelease/`` for example). To do so, go to the directory properties, and tick the option ``Derived``. Notice that derived directories known by Eclipse (such as :file:`Release/`) are automatically tagged as ``Derived``.

For non-derived directories that must be excluded, you can always create a ``Working set`` from the search dialog, though you must update the working set each time you add new directories.

Project configuration to work with PELE
---------------------------------------

To help Eclipse in recognizing your code, you have to give it the location of all your include files. To do so, go to the project properties, and then to ``C/C++ Build > Settings``. There, under ``GCC C++ Compiler > Includes`` you must add all the external includes, which are:

- For OpenMPI.
- For Jsoncpp.
- For Wjelement.

Eclipse only indexes and searches on the active code, as defined by the set of defines it uses. You can configure which defines you want (for example, ``MPI_CODE``) by editing ``GCC C++ Compiler > Preprocessor``.

Also, remember to select the standard of C++ you want to use (under ``GCC C++ Compiler > Dialect``).

If you necessarily need to build the project with Eclipse instead of with CMake, you will also need to configure the following:

- To detect all warnings, you will want to tick the options ``-Wall`` and ``-Wextra`` under ``GCC C++ Compiler > Warnings``.
- To allow all error messages to clearly appear in the Eclipse build log window, add these flags under ``GCC C++ Compiler > Miscellaneous``: ``-c -fmessage-length=0  -Wno-unknown-pragmas``.
- Under ``GCC C++ Linker > Libraries``, all the libraries, such as the jsoncpp one, cryptopp, wjelement, boost libraries, BLAS and LAPACK. If you give the exact name of the library, start the library filename with a colon. For example, to exactly link to :file:`libblas.so.3`, add `:libblas.so.3`. Remember to add the directories where librares are searched under the ``-L`` option. To link to libYaleMod, you will probably want to build it beforehand, and then link by adding it under ``GCC C++ Linker > Miscellaneous``, ``Other objects``.

Configuration to debug PELE with Eclipse and CMAKE
--------------------------------------------------

Being able to debug properly is an important factor when developing a software. With Eclipse, like most of others IDEs, you can set up breakpoints to stop the flow of the code. The previous will allow you to check variable values, and follow line by line what the code is doing. If you want to do this with PELE, you will need to configure Eclipse to use CMAKE as you would do on your command line. You can as well establish different build configurations, such as Debug, Production, etc.

**Setting Eclipse to build PELE:**

In order to build a cloned pele project, first you must go to ``File > Import... > Existing Code as Makefile Project``. Then, you must select the location in ``Existing Code Location`` and ``Linux GCC`` in ``Toolchain`for Indexer Settings``.

In Eclipse you can have differents Build Configurations. In ``Project > Properties > C/C++ Build`` you can create a new configuration to build and execute PELE with debug information. In (top right) ``Manage Configurations... > New...`` you can create a new configuration, in this case we can name it *Serial Test Debug*. Then you can swap between your configurations with ``Set Active > OK``.

Again, in ``Project > Properties > C/C++ Build`` you can personalize your Build. You must have `cmake4eclipse <https://marketplace.eclipse.org/content/cmake4eclipse>`__ installed and it will appear under ``C/C++ Build``. In ``Cmake4eclipse > General > Pre-populate CMake cache entries from file -C`` you must put the absolute path of your cache file, because somehow it does not work with a relative path. 

Then, in ``C/C++ General >  Path and Symbols > Includes > Languages (GNU C++)`` you must add the include folders of cryptopp, jsoncpp, wjelement and boost.
Remember that you can set up this libraries depending on which configuration are you in.

Finally, in ``C/C++ Build > Tool Chain Editor > Current builder`` choose ``CMake Builder (portable)``. If you want to build faster, in ``C/C++ Build > Behavior`` you can select ``Enable parallel build``. 

**Setting a Debug configuration**

For an specific Debug executable, in ``C/C++ Build > CMake4eclipse > Symbols > CMake cache entries to create (-D)`` you need to add the flags needed to build PELE in debug mode. Those flags are:

- ``BUILD_REDISTRIBUTABLE`` as a ``BOOL`` with value ``OFF``
- ``DEBUG`` as a ``BOOL`` with value ``ON``
- ``PRODUCTION`` as a ``BOOL`` with value ``OFF``
- ``USE_MPI`` as a ``BOOL`` with value ``OFF``

If your system has multiple boost libraries, and it's using the wrong one, you can tell cmake to not search for multiple boost libraries with:

- ``Boost_NO_BOOST_CMAKE`` as a ``BOOL`` with value ``ON``

Notice that you do not need to put ``-D`` in previous flags, like in a CMake call. This configuration we will build a PELE which will run all tests but MPI. After that, back to ``C/C++ Build > Builder Settings`` and click on ``Generate Makefiles automatically``.

Now, go to ``C/C++ Build > Settings > Tools Settings > GCC C++ Compiler > Debugging > Debug Level`` and choose ``Maximum (-g3)``.

Now that your configuration is done, we need to prepare a new launch Debug Configuration. In order to do this, we can go to ``Run > Debug Configurations...``. In the top left corner you can click on ``New launch configuration``, that will appear under ``C/C++ Application``. There you can change it's name, select the propper executable, and enable auto build, so you don't need to build separately from execution.

In ``(x)=Arguments`` you can put the flags needed. In this case, you will need the path to the license folder, and, alternatively, a path to a file where you can choose what tests do you want to run with ``--test-list-file <path>``, instead running all tests.

Also, in ``Debugger``, you can deselect ``Stop on startup at: main``, so it will not stop until your first breakpoint.

**Uses of Debug Execution**

Now, you can set up breakpoints to debug the code. When a breakpoint is reached, you can check any variable that is stored in that scope. If it is an array, or a dictionary for example, you can access to it's methods and positions in ``Expression`` tab, top right. You can enable/disable in an faster way your breakpoints in ``Breakpoint`` tab, instead of navigate again through the code. There are as well some options to debug step by step, for example with this shot-cuts:

- ``Step Into (F5)``. If you are in a function call, you can enter to that function to see what happens inside.
- ``Step Over (F6)``. Go to the next line. If in between there exists a breakpoint, it will stop there.
- ``Step Return (F7)``. If you want to end that method, and go where it ends or returns it's value.
- ``Resume (F8)``. Automatically advance until the next breakpoint, or end the execution if there are no breakpoints left.


More Short-cuts
---------------

- **Ctrl+click** on identifier: Go to declaration or definition (if at declaration) of the identifier.
- **F4** on class name: Go to class hierarchy.
- **Ctrl+Tab**: Switch between source (:file:`*.cpp`) and declaration (:file:`*.hpp`) of a file.
- **Shift+Ctrl+R**: Open resource (usually, a source code file).
- **Alt+Left**: Go back to previous view in history.
- **Alt+Left**: Go forward to the next view in history.
