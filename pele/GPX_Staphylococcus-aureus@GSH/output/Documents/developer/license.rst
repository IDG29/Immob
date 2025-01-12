.. _sec-dev-license:

************
PELE License
************

PELE uses the open source licensecc project to issue licenses and check them from PELE. Licensecc provides a license generator and a C++ API to check the signature of a license. 

The verification of the signature is done from src/Tools/License.cpp. The enforcements of any possible limitations associated with a license is done both in src/Tools/License.cpp and src/Tools/LicensePolice.cpp.

License type
============

Currently 2 types of licenses are supported. An academic license (limited, for a specific machine) and a professional license (unlimited, for a specific machine).

Academic license
----------------

The academic license is issued for a specific machine and has several additional limitations:

* Specific value of BUILD_TAG: determined during compilation, checked at License.cpp
* Specific version of PELE: determined during compilation, checked at License.cpp
* Maximum number of cpu cores: 30, checked at LicensePolice.cpp

The limitation of the Maximum number of PELE steps (20) is currently not active. 

Professional license
--------------------

Issued for a specific machine, no additional limitations.


How to issue licenses
=====================

Licenses can be issued using the lccgen binary located in the installation directory of licensecc (install_dir/bin/lccgen). The Issuer scripts in the NBD License repo (https://github.com/NBDsoftware/Licenses) facilitate the process of license generation for PELE. To see available options and details check out the licensecc manual (http://open-license-manager.github.io/licensecc/index.html), the Github examples (https://github.com/open-license-manager/examples/tree/develop/program_features) or do:

    lccgen license issue --help

Each license is issued using a specific private key defined in the project folder passed to lccgen. This same project has to be used when compiling PELE and linking the corresponding licensecc library (liblicensecc_static.a). The project is chosen during compilation setting the LCC_PROJECT_NAME environment variable. Each project folder refers to a different software we are going to issue licenses for and contains specific settings for the project. 

Create custom project
---------------------

To create a new project either compile licensecc again using a different value for LCC_PROJECT_NAME or use lccgen to generate a new project.  