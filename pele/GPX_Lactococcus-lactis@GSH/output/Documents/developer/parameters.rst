.. _sec-dev-parameters:

**********************
Force Field Parameters
**********************

In PELE, you can use the following force fields:

- OPLS 2005
- AMBER99sbBSC0

You can check :ref:`sec-dev-fileFormats` for details on the formats of the parameter files.

OPLS 2005
=========

This is the main force field used in PELE. It is based on the parameters of OPLS 2005 used in the Schrödinger molecular modelling software suite, and explained in [banks:2005]_. See http://www.schrodinger.com/kb/546 (a new version, OPLS3, is now included with the Schrödinger suite, but not PELE, and is described at https://www.schrodinger.com/science-articles/force-field). In Maestro, the OPLS2005 parameters are at :file:`$SCHRODINGER/mmshare-vversion/data/f14/`). The contents of this directory are (reproducing ftp://ftp.schrodinger.com/support/hidden/TS/modifying_opls.txt):

.. code-block:: text

    ======================================================================
    ==                         Modifiying OPLS                          ==
    ======================================================================
    OPLS_2005 parameter files are located in...

    $SCHRODINGER/mmshare-v<version>/data/f14/

    ..and the OPLS_2001 parameter files are in...

    $SCHRODINGER/mmshare-v<version>/data/f11new/

    Note: Starting with the Schrodinger Suite 2011 release (mmshare v2.0),
    the parameter files in these directories are versioned with a prefix
    (e.g., 'f14_oplsaa.type').

    oplsaa.type
    -----------
    Add lines in this file for your new atom type or types. There is a
    header at the top.  Note that there is a number and two labels (vdW
    and symbol) associated with the type; these are used in other
    parameter files.  If your new type is similar to an existing one, you
    might be able to reuse existing vdW and/or symbol types, which would
    reduce the number of new parameters that must be added to the other
    files.

    oplsaa.vdw
    ----------
    Add a line for the vdW type, with sigma and epsilon parameters.

    oplsaa_simil.tbl
    ----------------
    This sets the rules for approximate matches (i.e., what types are
    similar to other types).  Add a line for the new "symbol" type
    (instructions at the top).  You may only need to add an OPLSAA type
    entry, not actual similarity rules (lower down in the file).

    oplsaa.bci
    ----------
    This specifies the polarities of bonds between atom types so that
    partial charges can be distributed.  Add entries for the new type and
    atom types to which it will be bonded.  The types are specified by
    their numeric type rather than a label.  Note that the order of the
    atoms is significant.

    stretch.dat, bend.dat, torsion.dat, paramstd.dat
    ------------------------------------------------
    These files holds the bond stretch, angle-bending, and torsion
    parameters.  For OPLS_2005, there are separate files for the stretch,
    bend, and torsion parameters, while for OPLS_2001 all the parameters
    are combined in a single 'paramstd.dat' file.	For the stretch and
    bend entries, you'll give the 'symbol' labels involved in the
    interaction, the force constant, and the equilibrium value.  For the
    torsion entries, you'll give the amplitudes at the various Vn
    periodicities and the types involved.	The torsion parameters for
    OPLS_2001 are specified a bit differently; there are lines for each
    periodicity, with the amplitude and phase given for each.

    sgbnp.param
    -----------
    In the 2008 Suite, Impact/Glide 5.0 reads this SGB parameter file
    even when continuum solvation isn't used.  Therefore, it is necessary
    to add lines for your new symbol types to this parameter file if
    you're using Impact/Glide 5.0 or newer.

    Other
    -----
    If your new atom type will be involved in complex or tricky Lewis
    structures, you may run into trouble, because there are other
    parameter files for dealing with special situations, resonances, etc.
    'special_fragments.dat' is one such file.  Also, there may be other
    changes needed to run new types with our continuum solvation models.

    For example, to support selenate, a line...

    0 6 [SeX4](=[OX1])(=[OX1])(-[*])-[*] !!! # Selenate

    ...must be added at the end of the...

    $SCHRODINGER/mmshare-v<version>/data/mmlewis/special_fragments.dat

    ...file.

    You can either modify all these files in your Schrodinger installation
    (backing up the originals), or you can keep copies in the directory
    where you're running the job.	Note, however, that local copies will
    work only for locally-run jobs, because modified parameter files don't
    get transferred to job scratch directories.

    You also can place the modified parameter files in
    $HOME/.schrodinger/mmshare/.  However, this directory is not versioned
    for the force field, so if you place OPLS_2005 files in this
    directory, you won't be able to run OPLS_2001 jobs due to incompatible
    parameter files, unless you are running Schrodinger Suite 2011 or newer
    (in which the parameter file names themselves have version prefixes).

    You also can set the environment variable OPLS_DIR to point to
    the base directory of your own hierarchy of OPLS parameter files
    (i.e., your version of '$SCHRODINGER/mmshare-v<version>/data').


    In addition to these OPLS parameter files, you may need to modify a
    few additional files in...

    $SCHRODINGER/impact-v<version>/data/opls/

    ...to use the new types with Glide or Impact.

    badat.dat, badat_2005.dat
    -------------------------
    This file lists atomic numbers that are unsupported in Impact, due to
    occasional atom typing problems.  To allow a "forbidden" element,
    remove the line for atomic number, and decrease the value on the first
    line (i.e., the number of entries) by one.  Selenium is in the 'badat'
    list for OPLS_2001 (badat.dat) but not for OPLS_2005 (badat_2005.dat).

    ljtrans_new.dat
    ---------------
    A Glide-specific file for vdW parameters.  Add a line at the end for
    the new 'symbol' label, and give it the next available number. This
    will be the line number (counting from 0) in the 'ljparam_new.dat'
    file.	This file is no longer used starting with Glide 5.0.

    ljparam_new.dat
    ---------------
    At the end, list the sigma/2 and epsilon vdW parameters for the new
    symbol type indexed in 'ljtrans_new.dat'.  This file is no longer used
    starting with Glide 5.0.

    ptype.def
    ---------
    You may not need to modify this file, but it probably would be a good
    idea.  It contains categorical assignments (e.g., donor, hydrophobic)
    for various atom types, which can affect their participation in
    various scoring terms.  You could copy the [SX4] line, which is the
    "general nonpolar" default for sulfur.


    ==============================
    Viewing force field parameters
    ==============================
    You can view the force field parameters assigned to your structure
    with a special force-field utility, or by running an Impact or
    MacroModel job.

    Utility
    -------
    Run the 'ffld_server' utility.  For example...

    $SCHRODINGER/utilities/ffld_server -imae myfile.mae -print_parameters

    The default force field used by this utility is OPLS_2005, but this
    can be changed with the '-version' flag.  Running the utility without
    arguments will print usage information.  This is the easiest way to
    view the assigned parameters.

    Impact
    ------
    Set up a zero-step Impact minimization job, and Write out the job
    files.  Then, edit the '<jobname>.inp' file to add the keyword
    'pparam' at the end of the "build types..." line of the CREATE block,
    Finally, run the job from the command line...

    $SCHRODINGER/impact [-HOST <host/queue>] <jobname>.inp

    The force field parameter tables for the structure will be printed to
    the '<jobname>.log' file.


    MacroModel
    ----------
    Run a MacroModel "Current Energy" job, choosing "Energy listing:
    Complete" on the ECalc tab.  This job will create a '<jobname>.mmo'
    file that can be read by our Force Field Viewer (on the Tools menu).
    The Force Field Viewer shows the force field parameters and energy
    contributions for all the various interactions (vdW, electrostatic,
    torsions, etc.).

    ============================================================


As explained also in https://www.schrodinger.com/kb/239 if one needs to modify the Lennard-Jones parameters, one should change both :file:`oplsaa.vdw` and :file:`oplsaa.type`.

The main files, regarding PELE, are:

- :file:`f14_oplsaa.type`: It contains the atomic types, with information on how to detect those atoms. The first column is the numeric number assigned to that type; the second column is the van der Waals type, as used in :file:`f14_oplsaa.vdw`; the third column is the atom type used for all other parameterizations (stretch, bend, torsion and improper_torsions), but not for the SGBNP continuum solven model (in :file:`f14_sgbnp.param`), which uses its own types in :file:`f14_consolv:type`).
- :file:`f14_oplsaa.vdw`: It contains the sigma and epsilon parameters for the van der Waals types described in :file:`f14_oplsaa.type`. 
- :file:`f14_spread_formal_charge.dat`: It contains the initial charges spread among a group with a forma charge, according to the partial charge assignment algorithm mentioned in [banks:2005]_. There is also a :file:`f14_spread_zob_formal_charge.dat`, with an unknown usage.
- :file:`f14_oplsaa.bci`: BCI bond polarities, to distribute the partial charges after the initial spread.
- :file:`f14_sgbnp.param`: The parameters (radii, gamma and alpha) for the SGB+NP model.
- :file:`f14_consolv.type`: The atomic types used to assign the SGBNP parameters in :file:`f14_sgbnp.param`. These types are different from the types used to assign all the other force field parameters. For example, HC7 appears in this file, and the corresponding parameters are in the SGBNP parameter file, but that type does not appear in the :file:`f14_oplsaa.type` file.
- :file:`f14_stretch.param`: The parameters for bond stretching terms in the potential function.
- :file:`f14_bend.dat`: The parameters for the angle terms in the potential function.
- :file:`f14_improper_torsions.dat`: The parameters for the improper torsions in the potential function.
- :file:`f14_torsion.dat`: The parameters for the angle torsions in the potential function.

As stated in the documentation above, and in https://www.schrodinger.com/kb/809 you can
get all the OPLS2005 parameters for a given molecule by running:

.. code-block:: console

  $ $SCHRODINGER/utilities/ffld_server -imae input.mae -version 14 -print_parameters -out_file test1.log
  
Notice that this utility also calculates the atomic partial charges, that are probably
calculated using the BCI bond polarities after spreading the formal charge. It is possible
however to use already provided charges; see https://www.schrodinger.com/kb/1265

It is not clear if the above information also includes enough data to detect if 
some of the atoms involved in dihedrals should be included in the 1-4 interactions
when calculating the energy (see section PHI in the IMPACT template file format
documentation in the user's manual).

AMBER99sbBSC0
=============

TODO.

