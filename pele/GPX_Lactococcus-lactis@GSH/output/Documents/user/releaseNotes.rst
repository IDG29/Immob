#############
Release notes
#############

*******************************
Version 1.8.0
*******************************

- New **Non Bonding Energy By Selection** metric.
- New **Internal Energy** metric.
- New **perturbAllAtOnce** flag to perturb a chain with all its components at the same time.
- New **allowMultipleBindingSelection** flag to be able to select a chain with multiple parts for calculate the **Binding Energy**.
- ANM modifications so it can run without a protein in the system. New ANM **NULL** can be set to enable this option. 
- New **skipGlobalMinimization** flag in **SideChainPrediction** to ignore minimization after side chain prediction.
- Modifications to dummy atom using OpenFF forcefield.
- Fixed bugs with dummy atoms and vacuum simulations.
- PELE now requires less memory to run.
- New licensing system that uses LCC library can issue node-lock licenses.
- Invalid geometries are now attempted to be fixed instead of raising a runtime exception.
- Test fixes
- Changed from frozenAtomSurfaceContribution matrix to on the fly calculation
- Added test for **moveAllAtOnce**.

*******************************
Version 1.7.1
*******************************
- Implemented the PELE **MinimumSteps** feature.
- Fixed rotamer libs (ASQ, PTR, SEP, TPO).
- Fixes small issues in Side Chain Prediction and Side Chain Perturbation.

*******************************
Version 1.7
*******************************
- **Open Force** Field integration:
    - A new force field class (OpenForceField) is added to PELE.
    - A new template reader for the ACE method.
    - Solvent parameters setter for the new template reader.
- Implemented a new type of perturbation algorithm, **Side Chain Perturbation**.
- Added a new rectriction to PELE called **Interaction Restriction**.
- Implementation of a new perturbation type: **Conformation Perturbation**.
- Implementation of a **non-bonding energy calculator**.
- Implementation of 3 new constraints: **Angle Constraint**, **Dihedral Constraint** and **Variable Dihedral Constraint**.
- Added a new metric to compute angle between three atoms.
- Added a new logging functionally, called Inter Step logger.
- A **new flag at WaterPerturbation::parameters** section can manage PELE exceptions when water selectors are empty.
- Fixed minor memory leaks introduced in the 1.6.1 version, related to rotamers and water sites.
- Now EXIT_FAILURES errors will be **printed in console**.
- Implemented PELE **coverage** calculation.
- Fixed more tests.


*******************************
Version 1.6.1
*******************************
- New algorithm is performed when doing a Ligand Perturbation, if the Ligand has a large number of rotable bonds. The rotable bonds now will be **randomly selected** following a freedom criteria. This is done in **each group**.
    - If there are 3 or less rotable bonds, all are studied and no random selection is done.
    - If there are more than 3 rotable bonds:
        - If the lowest resolution is < 30, **3** rotable bonds will be randomly selected.
        - It not, **5** rotable bonds will be randomly selected.
- Behaviour improvements for **WaterMC** in Ligand Perturbation algorithm.
- Default **Steering Value** changed from 2 to 1.
- Default **Steric Trial** value changed from 1000 to 50.
- Fixed and refactored Tests.
- Fixed some errors with Simbolic Link creation in MNIV and NORD3.
- Some errors now are printed properly through cerr and not cout.
- Fixed memory leaks.
- Changed error outputs from cout to cerr. Errors now should be displayed in terminal.

***********
Version 1.6
***********
- **Cylindrical boxes** can be defined for the ligand perturbation with the new *CylindricalBox* option.
- **Multiple spherical** boxes can also be defined for the ligand perturbation with the new *MultiSphericalBox* option.
- New **WaterPerturbation** (wMC) step is included in the PELE algorithm to explore water sites along the simulation with a Metropolis Monte Carlo approach.
- **WaterSites** are regions where the user can specify explicit water molecules that need to be perturbed inside a certain spherical box in the wMC step.
- **LigandPerturbation** algorithms are changed to allow the ligand to be placed over explicit water molecules that are perturbed in the wMC step.
- New **verbose mode** allow the user to chose between an extended or a condensed logfile.
- Some repeated and useless lines were removed from **logfile ouputs**.
- **Symbolic links** to Data and Documents folders are automatically created when PELE initiates.
- In case the **output folder** does not exist, it will be created when PELE initiates.
- Several issues with **PELE tests** were solved in this release.
- Now when a atom is not found, instead printing **"total mass is too small: 0"** tells which atom and where is located.
- When running PELE in serial mode, **Complex keyword failure** has a better error description.
- Many **other minor changes** are introduced to improve the performance of PELE and to fix small issues.

********
rev12510
********

- Fix problem with spawning in machines with MPI implementations different from OpenMPI, such as MareNostrum IV (rev. 12509).
- Included latest version of PlopRotTemp.py which now works with Maestro 2017 format (rev. 12500).

********
rev12489
********

- Reorganize installation directory structure.
- Add script calculatePCA4PELE.py to calculate PCA components for the PELE simulation (rev. 12484).
- Add link to Adaptive PELE in the documentation.
- Check the number of nodes in pre-loaded normal modes is coherent with the one in the control file (rev. 12458).

********
rev12455
********

- Allow real time control of the simulation (for PELE-GUI) (rev. 12416).
- Honor "tag" field in configuration of metrics. This affects the header of the report file; in particular, "AcceptedSteps" becomes "numberOfAcceptedPeleSteps" and "Energy" becomes "currentEnergy" (rev. 12377).
- Detect wrongly formatted OBC parameter files, regarding missing fields and usage of non-numbers in a numeric field (rev. 12376).
- Improvements in documentation.

********
rev12360
********

- Partial support for insertion codes in PDB files, since selection still does not work in all cases (rev. 12311).
- More flexible templates allowed, with any number of spaces at the end of ATOM lines (rev. 12318).
- Removed test templates and other data files from the distributed Data/ directory (rev. 12322).
- Fixed assignment of dihedrals and 1-4 lists of 4-member rings in ligands (rev. 12346).
- Improvements in documentation.

********
rev12308
********

- Improvements in documentation and error reporting.
- Fix problem with steering non working right when being activated/deactivated through changeable parameters using a zero update frequency. Now, steering can be safely activated/deactived in that way (rev. 12251).
- Detect a bond in a ligand rotamer library does not actually exist (rev. 12286).
- Change default rotamer resolution to 10 degrees, both in perturbation and in side chain prediction phases (rev. 12289).
- Pass per-complex configuration properties in the control file (fixTrees, fixChainNames, allowMissingTerminals) to global properties (top level properties under "Initialization"), so that they apply to all PDB reading in the simulation, and not in a per-complex basis (rev. 12308).

********
rev12183
********

- Improvements in documentation.
- Fix problem of automatic assignment of templates for HIS residues according to its protonation (rev. 12179).
- Atom Pulling functionality implemented by Israel Cabeza de Vaca is now available (rev. 12081).
- Check the atoms of all residues in a PDB file match the atoms in the corresponding templates (rev. 12062).
- Fix: allow empty ligand rotamer library files for rigid ligands (rev. 12061).
- Fix: fail when a missing improper dihedral parameter is needed (rev. 12060).
- Default values for control file parameters change (rev. 12043).
- Command line parameter --license-directory eases indication of the directory with the license (rev. 12032).
- Control files now allow line comments (rev. 12030).

********
rev12025
********

- Perturbation boxes now check for the center of mass of the atoms, instead of forcing that all atoms must be inside the box (rev. 12015).

********
rev11996
********

- Fix: Energy calculation at step 0 when using SASA metric is now correct (rev. 11994).
- Improved control file checks and error messages (problems with selections, empty PDBs, duplicate atoms in PDB, missing template files, etc.).
- New documentation (rev. 11905 through rev. 11941)
- "failsafe" option in Side Chain Prediction (rev. 11904).
- New parameter to control the actual range used when choosing an angle at random for ligand perturbation (rev. 11900).

********
rev11893
********

- Improved documentation.
- Improved log information about side chain prediction (when it fails), ANM parameters and chain charges (rev. 11890, 11756, 11729).
- New condition, based on step frequency, to control changeable parameters (rev. 11853).
- Initial and final PDBs are now only stored if explicitly said in the control file (rev. 11822).
- Fix: ASH and GLH rotamer libraries (rev. 11795).
- Fix: GB alphas calculation / solvation energies calculation when part of the system was frozen, as in the side chain prediction phase (rev. 11750).
- RMSD metric now alows different selection for alignment and for calculation (rev. 11738).
- RMSD metric now works with native structures that differ from the simulated structure (rev. 11736).
- exponentialDistanceDecay (in ANM) is now a changeable parameter (rev. 11730).
- Minimization selections (includeInMinimization, doNotIncludeInMinimization) now affect ANM (rev. 11686).


********
rev11678
********

- Boltzmann sampling Side Chain Prediction (rev. 11674).

********
rev11670
********

- Change steering vector when perturbation steric try goes out of the box (rev. 11669).
- Reject PELE step when perturbed atom set ends out of the box (rev. 11669).
- Improved logging: 

    - Added residue number when logging constraints (rev. 11665).
    - Identify missing atom for applying rotamers (rev. 11664).

- Atom Pulling changes in the way to compute bead positions (rev. 11661).
- Fix: Parameters from the command configuration are now inherited at the task level (rev. 11654).
- Changeable parameters section applied from the beginning, before step 1 (rev. 11621).

********
rev11620
********

- Disulfide bonds excluded from side chain prediction (rev. 11563).
- Improved logging: 

    - List of links studied in side chain prediction and minimization (rev. 11601).
    - Steering configuration reported for metropolis perturbation (rev. 11583).
    - Logging available for all commands (rev. 11546).
    - Warnings when using minimization radius, and the whole protein is selected (rev. 11521).

- Added keyword "empty" for selections (rev. 11510).
- Fix broken vacuum calculations (rev. 11492).
- Atom Pulling (rev. 11488).


********
rev11368
********

- In the "parametersChanges" section, if the value for updateSteeringFrequency is not different from the current one, then the change is ignored (that is, the internal counter to decide when to update the steering vector is not reset). (rev. 11368).
- Fixed updateSteeringFrequency as a changeable parameter, and deactivate steering when this parameter is 0 (rev. 11360).
- Added PELE version information to log, output, and --version command-line argument (rev. 11346).


********
rev11362
********

- Fixed updateSteeringFrequency as a changeable parameter, and deactivate steering when this parameter is 0 (rev. 11360).
- Added PELE version information to log, output, and --version command-line argument (rev. 11346).

********
rev11335
********

- Added steering to Metropolis perturbation (rev. 11335).
- New default of 200000 K for the `temperature` parameter of Metropolis perturbation (rev. 11263).

********
rev11260
********

- Parameter to force perturbation to keep trying until accepting at least one trial (rev. 11257).

********
rev11227
********

- Pele steps now start at 1, and the initial state is included in the report and trajectory (rev. 11151).

********
rev11145
********

- Proximity distance checks to skip unneeded updates (rev. 11140).
- Control file validation (rev. 11123).


********
rev11122
********

- `./DataLocal/` directory for overwriting data files (rev. 11107).
- Default overlapFactor of 0.7 (rev. 11102).
- Centered and spherical translation range (rev. 11067).
- Update pele regions every perturbation try (rev. 11066).


********
rev11056
********

- Reading ANM modes from file (rev. 11056).

