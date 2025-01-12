.. _sec-dev-fileFormats:

*****************
PELE File Formats
*****************

Template file / Ligand database file
====================================

These files are divided between the template files for internal link parameters, which follow the IMPACT format, and those for interlink parameters, which follow a custom PELE format.

The format is described in the user manual.

The IMPACT template format is codified in class ``ImpactTemplateReader``, and the PELE one in ``PELECustomTemplateReader``. Both are subclasses of ``TemplateReader``.

Templates are read from a ``Forcefield`` object.

Non bonded parameters
---------------------

- sigma values are internally stored multiplied by a *sigmaScaling* factor (probably for efficiency reasons; its value is :math:`0.5` for the OPLS force field) so that, when calculating the lennard-jones energy, the actual value in kcal/mol is obtained.
- epsilon is interally stored as :math:`2 \sqrt{\epsilon_{ii}}`, probably for efficiency reasons when doing the lennard-jones energy calculation.
- charge values are stored by multiplying by ``PhysConsts::CHARGE_CONVERSOR`` (18.222617), so that the Coulomb energy results in kcal/mol (when using the formula :math:`q_i q_j / d` where :math:`d` is in Angstroms).




Non-ligand rotamer library file
===============================

Free rotamer libraries
----------------------

Notice however that the :file:`FRE{X}.side` files are not currently used and, instead, any real resolution that is a result of dividing 180 among 1..17 is allowed, plus number 5. This is because, internally, the polar library of iper 1 for the given resolution is chosen. See `LigandSideChain::addSideChainBranches()` which calls to `SideChain::addBranch()`, which does the actual rotamer library selection.


Ligand rotamer library file
===========================

This file format is based on the one used in PLOP: http://wiki.jacobsonlab.org/index.php/Rot#rot_assign

Group definition
----------------

Given that a dihedral (or torsion) angle (see the IUPAC Gold Book entry http://goldbook.iupac.org/T06406.html) is defined by atoms A-B-C-D, these atoms must be B and C, and in that order. Notice that this format implieas:

1. There is only one atom (or, at least, heavy atom) connected to atom B, apart from atom C. This atom (A), is the parent of B in the PELE `AtomsTree` structure.
2. Atom D is the atom in PELE `AtomsTree` such that C is its parent, and B is its grand parent.

Elements Parameters file
========================

This information is stored in objects of class `ElementsParameters`, and they are internally stored in an attribute of `ElementParametersLoader`. They are assigned to the atoms of a complex through `ElementParametersLoader::setElementsParameters()`.

Residue table
=============

Its contents are represented by class `LinkTypesTable`. The type of a link is stored in an object of class `LinkData`.

Formal charges
==============

See `FormalChargesCalculator::assignFormalCharges()` and :file:`Data/params.formalcg`.

The file is read with `System::loadFormalCharges()`, and the contents stored in `FormalChargesCalculator::formalChargesByLinkNameAndAtomType`.

ConstraintTerm serialization
============================

Serialization of ConstraintTerm objects currently considers only harmonic constraints on atoms and harmonic constraints on distances. Several constraints can be serialized in the same file, sequentially.

Constraint information, especially numerical one, is written in binary, to allow exact replication when deserializing.

The typical format for each constraint is:

- enum: identifies the constraint type.
- a field per data item in the constraint. Example: 

  - char[4] atom name
  - char[3] residue name
  - int residue sequence number
  - char[1] atom chain id
  - double spring constant
  - double equilibrium distance

To deserialize, the code needs access to an AtomSet which maps the atom identification (name, residue, etc.) to an actual Atom object.

.. _sec-dev-fileFormats-parameterRulesFileFormat:

Parameter rules file format
===========================

They are used in file :file:`Data/ParameterRules/parameterValuesRules.conf`.

It is a JSON file with a single `Rules` object, with as many members as different parameters are in the control file. Each member is an object with a `type` member and, depending on its value, additional members. The allowed types are:

- `string`: The parameter value must be a text string. The parameter object has an additional `options` member which is an array of allowed values for the parameter.
- `integer`: The parameter value must be an integer number. The parameter object has an additional `range` member which is an array with two values delimiting the range. The delimiters can be numbers or the special strings `inf` or `-inf`.
- `real`: The parameter value must be a real number. As for `integer`, the parameter object has an additional `range` member which is an array with two values delimiting the range. The delimiters can be numbers or the special strings `inf` or `-inf`.
- `boolean`: The parameter value must be either `True` or `False`. There are no additional object members.

.. warning::

  Even though the rules file has comments stating what section the parameter belongs to, those comments are not followed during the enforcement, so parameters with the same name are considered as a single parameter, and it is implementation dependent what rule is actually followed.

.. _sec-dev-fileFormats-residueTable:

Residue table
=============

See file :file:`Data/res_table.dat`.

Currently, only the following fields are considered:

- Characters 0-3: The name of the link.
- Characters 37-39: The type of link.

Links can belong to one of the following types. Guesses for the meaning are in parentheses.

- gly (a glycine residue)
- non (an apolar residue)
- chg (a charged residue)
- pol (a polar residue)
- ntc (an N-terminal residue)
- rna (RNA residue)
- ctc (a C-terminal residue)
- ion (an ion)
- hoh (a water molecule)

.. _sec-dev-fileFormats-formalCharges:

Formal charges
==============

One line per atom type. Each line has:

- Residue type
- Atom type
- Formal charge

Sample file:

.. code-block:: text

    ALA___O2__-0.5
    ALA___N3___1.0
    ARG___N2___0.333333333333333
    ARG___O2__-0.5
    ARG___N3___1.0
    ASN___O2__-0.5
    ASN___N3___1.0
    ASP___O2__-0.5
    ASP___N3___1.0
    CYS___O2__-0.5
    CYS___N3___1.0
    GLN___O2__-0.5
    GLN___N3___1.0
    GLU___O2__-0.5
    GLU___N3___1.0
    GLY___O2__-0.5
    GLY___N3___1.0
    HIS___NA___0.5
    HIS___NB___0.5
    HIS___O2__-0.5
    HIS___N3___1.0
    HIE___O2__-0.5
    HIE___N3___1.0
    HID___O2__-0.5
    HID___N3___1.0
    ILE___O2__-0.5
    ILE___N3___1.0
    LEU___O2__-0.5
    LEU___N3___1.0
    LYS___NZ1__1.0
    LYS___O2__-0.5
    LYS___N3___1.0
    MET___O2__-0.5
    MET___N3___1.0
    PHE___O2__-0.5
    PHE___N3___1.0
    PRO___O2__-0.5
    PRO___N3___1.0
    SER___O2__-0.5
    SER___N3___1.0
    THR___O2__-0.5
    THR___N3___1.0
    TRP___O2__-0.5
    TRP___N3___1.0
    TYR___O2__-0.5
    TYR___N3___1.0
    VAL___O2__-0.5
    VAL___N3___1.0

Atom name conversions
=====================

The following table was obtained from http://www.bmrb.wisc.edu/ref_info/atom_nom.tbl 

.. code-block:: text

    # Correlation of hydrogen atom naming systems, including diastereotopic
    # protons. The original version of this table was created by Charles 
    # Hoogstraten.
    #
    # BMRB  = System in use at BioMagResBank (IUPAC/IUB Biochemistry 9, 3471-3479
    #	  [1970]).
    #
    # SC    = Stereochemical designations 
    #
    # UCSF  = Mardigras-type software (peptide protonated with newhyd utility).
    #
    # XPLOR = Peptide protonated with XPLOR 3.1.  Atom nomenclature is derived
    #	  from the X-PLOR topology file topallhdg.pro.  
    #
    # MSI   = Artificial peptide created with InsightII.  For the side chain
    #	  protons attached to nitrogen in ASN, GLN, and ARG, the atom
    #	  nomenclature does not reflect the potential stereoisomerism of the
    #	  planar amide and guanidinium groups.  The correlation with Z and E
    #	  nomenclature listed here simply reflects the state of the artificial
    #	  peptide generated as an example.  The CG1 and CG2 atoms for VAL in a
    #	  peptide generated by InsightII are not labeled according to IUPAC
    #	  rules, while the CD1 and CD2 atoms for LEU are.
    #
    # PDB   = PDB nomenclature (Taken from PDB entry 6I1B REVDAT 15-OCT-92.)
    #
    # SYBYL = The atom nomenclature was taken from the xxx.res files supplied with
    #	  the software package Sybyl version 6.2 from Tripos, Inc.  
    #
    # MIDAS = MidasPlus from the Computer Graphics Laboratory at UCSF.  The atom 
    #	  nomenclature has been taken from the XXX.ins files supplied with the
    #	  software.  The prochiral atoms have not been correlated with the
    #	  BMRB assignments at this time.  Hydrogens are not included in the
    #	  XXX.ins template files.
    #
    # Note-1: The prochiral methyl group names may reflect convention of code
    #	  generating heavy atom names if protons are added later.
    #
    # Note-2: '*' The stereochemical assignments for the named atoms have not been
    #	  determined for these software systems.
    #
    # Note-3: The Z and E nomenclature is defined in the paper by Blackwood, J.E.,
    #	  Gladys, C.L., Loening, K.L., Petrarca, A.E., and Rush, J.E., 
    #	  "Unambiguous Specification of Stereoisomerism about a Double Bond,"
    #	  J. Amer. Chem. Soc. 90, 509-510 (1968).
    #
    # Note-3: For the terminal amine and carboxyl atoms, 'X' has been used as a
    #	  dummy value for the amino acid type.
    #
    # Note-4: The terminal secondary amine protons for PRO have been included
    #	  with the other PRO atoms.
    #
    # Note-5: Fields in the table are separated by tabs.
    #
    # Note-6: Please report errors, updates, or extensions to Eldon Ulrich
    #	  (elu@nmrfam.wisc.edu)

    # A.A.		BMRB	SC	PDB	UCSF	MSI	XPLOR	SYBYL*	MIDAS*	DIANA
    # ----		----	----	----	----	----	-----	-----	-----	-----

    # Terminal amine protons

    X		H1		1H	HN1	HN1	HT1	HNCAP		
    X		H2		2H	HN2	HN2	HT2			
    X		H3		3H	HN3	HN3	HT3			

    # Terminal carboxyl atoms

    X		H''						HOCAP		
    X		O'		O		O	OT1	O	O	
    X		O''		OXT		OXT	OT2	OXT	OXT	

    # Residue atoms

    A		H		H	HN	HN	HN	H		HN
    A		HA		HA	HA	HA	HA	HA		HA
    A		HB1		1HB	HB1	HB1	HB1	HB1		HB1
    A		HB2		2HB	HB2	HB2	HB2	HB2		HB2
    A		HB3		3HB	HB3	HB3	HB3	HB3		HB3
    A		C		C		C	C	C	C	C
    A		CA		CA		CA	CA	CA	CA	CA
    A		CB		CB		CB	CB	CB	CB	CB
    A		N		N		N	N	N	N	N
    A		O		O		O	O	O	O	O

    R		H		H	HN	HN	HN	H		HN
    R		HA		HA	HA	HA	HA	HA		HA
    R		HB2	pro-R	1HB	HB1	HB1	HB2	HB2		HB2
    R		HB3	pro-S	2HB	HB2	HB2	HB1	HB1		HB3
    R		HG2	pro-S	1HG	HG1	HG1	HG2	HG2		HG2
    R		HG3	pro-R	2HG	HG2	HG2	HG1	HG1		HG3
    R		HD2	pro-S	1HD	HD1	HD1	HD2	HD2		HD2
    R		HD3	pro-R	2HD	HD2	HD2	HD1	HD1		HD3
    R		HE		HE	HNE	HE	HE	HE		HE
    R		HH11	Z	1HH1	HN11	HH11	HH11	HH11		HH11
    R		HH12	E	2HH1	HN12	HH12	HH12	HH12		HH12
    R		HH21	Z	1HH2	HN21	HH22	HH21	HH21		HH21
    R		HH22	E	2HH2	HN22	HH21	HH22	HH22		HH22
    R		C		C		C	C	C	C	C
    R		CA		CA		CA	CA	CA	CA	CA
    R		CB		CB		CB	CB	CB	CB	CB
    R		CG		CG		CG	CG	CG	CG	CG
    R		CD		CD		CD	CD	CD	CD	CD
    R		CZ		CZ		CZ	CZ	CZ	CZ	CZ
    R		N		N		N	N	N	N	N
    R		NE		NE		NE	NE	NE	NE	NE
    R		NH1	Z	NH1		NH1	NH1	NH1	NH1	NH1
    R		NH2	E	NH2		NH2	NH2	NH2	NH2	NH2
    R		O		O		O	O	O	O	O

    D		H		H	HN	HN	HN	H		HN
    D		HA		HA	HA	HA	HA	HA		HA
    D		HB2	pro-S	1HB	HB1	HB1	HB2	HB2		HB2
    D		HB3	pro-R	2HB	HB2	HB2	HB1	HB1		HB3
    D		HD2				HD2				HD2
    D		C		C		C	C	C	C	C
    D		CA		CA		CA	CA	CA	CA	CA
    D		CB		CB		CB	CB	CB	CB	CB
    D		CG		CG		CG	CG	CG	CG	CG
    D		N		N		N	N	N	N	N
    D		O		O		O	O	O	O	O
    D		OD1		OD1		OD1	OD1	OD1	OD1	OD1
    D		OD2		OD2		OD2	OD2	OD2	OD2	OD2

    N		H		H	HN	HN	HN	H		HN
    N		HA		HA	HA	HA	HA	HA		HA
    N		HB2	pro-S	1HB	HB1	HB1	HB2	HB2		HB2
    N		HB3	pro-R	2HB	HB2	HB2	HB1	HB1		HB3
    N		HD21	E	1HD2	HN21	HD21	HD21	HD21		HD21
    N		HD22	Z	2HD2	HN22	HD22	HD22	HD22		HD22
    N		C		C		C	C	C	C	C
    N		CA		CA		CA	CA	CA	CA	CA
    N		CB		CB		CB	CB	CB	CB	CB
    N		CG		CG		CG	CG	CG	CG	CG
    N		N		N		N	N	N	N	N
    N		ND2		ND2		ND2	ND2	ND2	ND2	ND2
    N		O		O		O	O	O	O	O
    N		OD1		OD1		OD1	OD1	OD1	OD1	OD1

    C		H		H	HN	HN	HN	H		HN
    C		HA		HA	HA	HA	HA	HA		HA
    C		HB2	pro-S	1HB	HB1	HB1	HB2	HB2		HB2
    C		HB3	pro-R	2HB	HB2	HB2	HB1	HB1		HB3
    C		HG		HG	HSG	HG	HG	HG		HG
    C		C		C		C	C	C	C	C
    C		CA		CA		CA	CA	CA	CA	CA
    C		CB		CB		CB	CB	CB	CB	CB
    C		N		N		N	N	N	N	N
    C		O		O		O	O	O	O	O
    C		SG		SG		SG	SG	SG	SG	SG

    E		H		H	HN	HN	HN	H		HN
    E		HA		HA	HA	HA	HA	HA		HA
    E		HB2	pro-R	1HB	HB1	HB1	HB2	HB2		HB2
    E		HB3	pro-S	2HB	HB2	HB2	HB1	HB1		HB3
    E		HG2	pro-S	1HG	HG1	HG1	HG2	HG2		HG2
    E		HG3	pro-R	2HG	HG2	HG2	HG1	HG1		HG3
    E		HE2				HE2				HE2
    E		C		C		C	C	C	C	C
    E		CA		CA		CA	CA	CA	CA	CA
    E		CB		CB		CB	CB	CB	CB	CB
    E		CG		CG		CG	CG	CG	CG	CG
    E		CD		CD		CD	CD	CD	CD	CD
    E		N		N		N	N	N	N	N
    E		O		O		O	O	O	O	O
    E		OE1		OE1		OE1	OE1	OE1	OE1	OE1
    E		OE2		OE2		OE2	OE2	OE2	OE2	OE2

    Q		H		H	HN	HN	HN	H		HN
    Q		HA		HA	HA	HA	HA	HA		HA
    Q		HB2	pro-R	1HB	HB1	HB1	HB2	HB2		HB2
    Q		HB3	pro-S	2HB	HB2	HB2	HB1	HB1		HB3
    Q		HG2	pro-S	1HG	HG1	HG1	HG2	HG2		HG2
    Q		HG3	pro-R	2HG	HG2	HG2	HG1	HG1		HG3
    Q		HE21	E	1HE2	HN21	HE21	HE21	HE21		HE21
    Q		HE22	Z	2HE2	HN22	HE22	HE22	HE22		HE22
    Q		C		C		C	C	C	C	C
    Q		CA		CA		CA	CA	CA	CA	CA
    Q		CB		CB		CB	CB	CB	CB	CB
    Q		CG		CG		CG	CG	CG	CG	CG
    Q		CD		CD		CD	CD	CD	CD	CD
    Q		N		N		N	N	N	N	N
    Q		NE2		NE2		NE2	NE2	NE2	NE2	NE2
    Q		O		O		O	O	O	O	O
    Q		OE1		OE1		OE1	OE1	OE1	OE1	OE1

    G		H		H	HN	HN	HN	H		HN
    G		HA2	pro-R	1HA	HA1	HA1	HA2	HA2		HA1
    G		HA3	pro-S	2HA	HA2	HA2	HA1	HA1		HA2
    G		C		C		C	C	C	C	C
    G		CA		CA		CA	CA	CA	CA	CA
    G		N		N		N	N	N	N	N
    G		O		O		O	O	O	O	O

    H		H		H	HN	HN	HN	H		HN
    H		HA		HA	HA	HA	HA	HA		HA
    H		HB2	pro-S	1HB	HB1	HB1	HB2	HB2		HB2
    H		HB3	pro-R	2HB	HB2	HB2	HB1	HB1		HB3
    H		HD1		HD1	HND1	HD1	HD1	HD1		HD1
    H		HD2		HD2	HD2	HD2	HD2	HD2		HD2
    H		HE1		HE1	HE1	HE1	HE1	HE1		HE1
    H		HE2			HNE2	HE2				HE2
    H		C		C		C	C	C	C	C
    H		CA		CA		CA	CA	CA	CA	CA
    H		CB		CB		CB	CB	CB	CB	CB
    H		CG		CG		CG	CG	CG	CG	CG
    H		CD2		CD2		CD2	CD2	CD2	CD2	CD2
    H		CE1		CE1		CE1	CE1	CE1	CE1	CE1
    H		N		N		N	N	N	N	N
    H		ND1		ND1		ND1	ND1	ND1	ND1	ND1
    H		NE2		NE2		NE2	NE2	NE2	NE2	NE2
    H		O		O		O	O	O	O	O

    I		H		H	HN	HN	HN	H		HN
    I		HA		HA	HA	HA	HA	HA		HA
    I		HB		HB	HB	HB	HB	HB		HB
    I		HG12	pro-R	1HG1	HG11	HG11	HG12	HG12		HG12
    I		HG13	pro-S	2HG1	HG12	HG12	HG11	HG11		HG13
    I		HG21		1HG2	HG21	HG21	HG21	HG21		HG21
    I		HG22		2HG2	HG22	HG22	HG22	HG22		HG22
    I		HG23		3HG2	HG23	HG23	HG23	HG23		HG23
    I		HD11		1HD1	HD11	HD11	HD11	HD11		HD11
    I		HD12		2HD1	HD12	HD12	HD12	HD12		HD12
    I		HD13		3HD1	HD13	HD13	HD13	HD13		HD13
    I		C		C		C	C	C	C	C
    I		CA		CA		CA	CA	CA	CA	CA
    I		CB		CB		CB	CB	CB	CB	CB
    I		CG1		CG1		CG1	CG1	CG1	CG1	CG1
    I		CG2		CG2		CG2	CG2	CG2	CG2	CG2
    I		CD1		CD1		CD1	CD1	CD1	CD1	CD1
    I		N		N		N	N	N	N	N
    I		O		O		O	O	O	O	O

    L		H		H	HN	HN	HN	H		HN
    L		HA		HA	HA	HA	HA	HA		HA
    L		HB2	pro-R	1HB	HB1	HB1	HB2	HB2		HB2
    L		HB3	pro-S	2HB	HB2	HB2	HB1	HB1		HB3
    L		HG		HG	HG	HG	HG	HG		HG
    L		HD11		1HD1	HD11	HD11	HD11	HD11		HD11
    L		HD12		2HD1	HD12	HD12	HD12	HD12		HD12
    L		HD13		3HD1	HD13	HD13	HD13	HD13		HD13
    L		HD21		1HD2	HD21	HD21	HD21	HD21		HD21
    L		HD22		2HD2	HD22	HD22	HD22	HD22		HD22
    L		HD23		3HD2	HD23	HD23	HD23	HD23		HD23
    L		C		C		C	C	C	C	C
    L		CA		CA		CA	CA	CA	CA	CA
    L		CB		CB		CB	CB	CB	CB	CB
    L		CG		CG		CG	CG	CG	CG	CG
    L		CD1	pro-R	CD1		CD1	CD1	CD1	CD1	CD1
    L		CD2	pro-S	CD2		CD2	CD2	CD2	CD2	CD2
    L		N		N		N	N	N	N	N
    L		O		O		O	O	O	O	O

    K		H		H	HN	HN	HN	H		HN
    K		HA		HA	HA	HA	HA	HA		HA
    K		HB2	pro-R	1HB	HB1	HB1	HB2	HB2		HB2
    K		HB3	pro-S	2HB	HB2	HB2	HB1	HB1		HB3
    K		HG2	pro-R	1HG	HG1	HG1	HG2	HG2		HG2
    K		HG3	pro-S	2HG	HG2	HG2	HG1	HG1		HG3
    K		HD2	pro-S	1HD	HD1	HD1	HD2	HD2		HD2
    K		HD3	pro-R	2HD	HD2	HD2	HD1	HD1		HD3
    K		HE2	pro-S	1HE	HE1	HE1	HE2	HE2		HE2
    K		HE3	pro-R	2HE	HE2	HE2	HE1	HE1		HE3
    K		HZ1		1HZ	HNZ1	HZ1	HZ1	HZ1		HZ1
    K		HZ2		2HZ	HNZ2	HZ2	HZ2	HZ2		HZ2
    K		HZ3		3HZ	HNZ3	HZ3	HZ3	HZ3		HZ3
    K		C		C		C	C	C	C	C
    K		CA		CA		CA	CA	CA	CA	CA
    K		CB		CB		CB	CB	CB	CB	CB
    K		CG		CG		CG	CG	CG	CG	CG
    K		CD		CD		CD	CD	CD	CD	CD
    K		CE		CE		CE	CE	CE	CE	CE
    K		N		N		N	N	N	N	N
    K		NZ		NZ		NZ	NZ	NZ	NZ	NZ
    K		O		O		O	O	O	O	O

    M		H		H	HN	HN	HN	H		HN
    M		HA		HA	HA	HA	HA	HA		HA
    M		HB2	pro-S	1HB	HB1	HB1	HB2	HB2		HB2
    M		HB3	pro-R	2HB	HB2	HB2	HB1	HB1		HB3
    M		HG2	pro-S	1HG	HG1	HG1	HG2	HG2		HG2
    M		HG3	pro-R	2HG	HG2	HG2	HG1	HG1		HG3
    M		HE1		1HE	HE1	HE1	HE1	HE1		HE1
    M		HE2		2HE	HE2	HE2	HE2	HE2		HE2
    M		HE3		3HE	HE3	HE3	HE3	HE3		HE3
    M		C		C		C	C	C	C	C
    M		CA		CA		CA	CA	CA	CA	CA
    M		CB		CB		CB	CB	CB	CB	CB
    M		CG		CG		CG	CG	CG	CG	CG
    M		CE		CE		CE	CE	CE	CE	CE
    M		N		N		N	N	N	N	N
    M		O		O		O	O	O	O	O
    M		SD		SD		SD	SD	SD	SD	SD

    F		H		H	HN	HN	HN	H		HN
    F		HA		HA	HA	HA	HA	HA		HA
    F		HB2	pro-R	1HB	HB1	HB1	HB2	HB2		HB2
    F		HB3	pro-S	2HB	HB2	HB2	HB1	HB1		HB3
    F		HD1		HD1	HD1	HD1	HD1	HD1		HD1
    F		HD2		HD2	HD2	HD2	HD2	HD2		HD2
    F		HE1		HE1	HE1	HE1	HE1	HE1		HE1
    F		HE2		HE2	HE2	HE2	HE2	HE2		HE2
    F		HZ		HZ	HZ	HZ	HZ	HZ		HZ
    F		C		C		C	C	C	C	C
    F		CA		CA		CA	CA	CA	CA	CA
    F		CB		CB		CB	CB	CB	CB	CB
    F		CG		CG		CG	CG	CG	CG	CG
    F		CD1		CD1		CD1	CD1	CD1	CD1	CD1
    F		CD2		CD2		CD2	CD2	CD2	CD2	CD2
    F		CE1		CE1		CE1	CE1	CE1	CE1	CE1
    F		CE2		CE2		CE2	CE2	CE2	CE2	CE2
    F		CZ		CZ		CZ	CZ	CZ	CZ	CZ
    F		N		N		N	N	N	N	N
    F		O		O		O	O	O	O	O

    P		H2	pro-R	H2		HN2	HT2			
    P		H3	pro-S	H1		HN1	HT1			
    P		HA		HA	HA	HA	HA	HA		HA
    P		HB2	pro-R	1HB	HB1	HB1	HB2	HB2		HB2
    P		HB3	pro-S	2HB	HB2	HB2	HB1	HB1		HB3
    P		HG2	pro-S	1HG	HG1	HG1	HG2	HG2		HG2
    P		HG3	pro-R	2HG	HG2	HG2	HG1	HG1		HG3
    P		HD2	pro-S	1HD	HD2	HD1	HD2	HD2		HD2
    P		HD3	pro-R	2HD	HD1	HD2	HD1	HD1		HD3
    P		C		C		C	C	C	C	C
    P		CA		CA		CA	CA	CA	CA	CA
    P		CB		CB		CB	CB	CB	CB	CB
    P		CG		CG		CG	CG	CG	CG	CG
    P		CD		CD		CD	CD	CD	CD	CD
    P		N		N		N	N	N	N	N
    P		O		O		O	O	O	O	O

    S		H		H	HN	HN	HN	H		HN
    S		HA		HA	HA	HA	HA	HA		HA
    S		HB2	pro-S	1HB	HB1	HB1	HB2	HB2		HB2
    S		HB3	pro-R	2HB	HB2	HB2	HB1	HB1		HB3
    S		HG		HG	HOG	HG	HG	HG		HG
    S		C		C		C	C	C	C	C
    S		CA		CA		CA	CA	CA	CA	CA
    S		CB		CB		CB	CB	CB	CB	CB
    S		N		N		N	N	N	N	N
    S		O		O		O	O	O	O	O
    S		OG		OG		OG	OG	OG	OG	OG

    T		H		H	HN	HN	HN	H		HN
    T		HA		HA	HA	HA	HA	HA		HA
    T		HB		HB	HB	HB	HB	HB		HB
    T		HG1		HG1	HOG1	HG1	HG1	HG1		HG1
    T		HG21		1HG2	HG21	HG21	HG21	HG21		HG21
    T		HG22		2HG2	HG22	HG22	HG22	HG22		HG22
    T		HG23		3HG2	HG23	HG23	HG23	HG23		HG23
    T		C		C		C	C	C	C	C
    T		CA		CA		CA	CA	CA	CA	CA
    T		CB		CB		CB	CB	CB	CB	CB
    T		CG2		CG2		CG2	CG2	CG2	CG2	CG2
    T		N		N		N	N	N	N	N
    T		O		O		O	O	O	O	O
    T		OG1		OG1		OG1	OG1	OG1	OG1	OG1

    W		H		H	HN	HN	HN	H		HN
    W		HA		HA	HA	HA	HA	HA		HA
    W		HB2	pro-R	1HB	HB1	HB1	HB2	HB2		HB2
    W		HB3	pro-S	2HB	HB2	HB2	HB1	HB1		HB3
    W		HD1		HD1	HD1	HD1	HD1	HD1		HD1
    W		HE1		HE1	HNE1	HE1	HE1	HE1		HE1
    W		HE3		HE3	HE3	HE3	HE3	HE3		HE3
    W		HZ2		HZ2	HZ2	HZ2	HZ2	HZ2		HZ2
    W		HZ3		HZ3	HZ3	HZ3	HZ3	HZ3		HZ3
    W		HH2		HH2	HH2	HH2	HH2	HH2		HH2
    W		C		C		C	C	C	C	C
    W		CA		CA		CA	CA	CA	CA	CA
    W		CB		CB		CB	CB	CB	CB	CB
    W		CG		CG		CG	CG	CG	CG	CG
    W		CD1		CD1		CD1	CD1	CD1	CD1	CD1
    W		CD2		CD2		CD2	CD2	CD2	CD2	CD2
    W		CE2		CE2		CE2	CE2	CE2	CE2	CE2
    W		CE3		CE3		CE3	CE3	CE3	CE3	CE3
    W		CZ2		CZ2		CZ2	CZ2	CZ2	CZ2	CZ2
    W		CZ3		CZ3		CZ3	CZ3	CZ3	CZ3	CZ3
    W		CH2		CH2		CH2	CH2	CH2	CH2	CH2
    W		N		N		N	N	N	N	N
    W		NE1		NE1		NE1	NE1	NE1	NE1	NE1
    W		O		O		O	O	O	O	O

    Y		H		H	HN	HN	HN	H		HN
    Y		HA		HA	HA	HA	HA	HA		HA
    Y		HB2	pro-R	1HB	HB1	HB1	HB2	HB2		HB2
    Y		HB3	pro-S	2HB	HB2	HB2	HB1	HB1		HB3
    Y		HD1		HD1	HD1	HD1	HD1	HD1		HD1
    Y		HD2		HD2	HD2	HD2	HD2	HD2		HD2
    Y		HE1		HE1	HE1	HE1	HE1	HE1		HE1
    Y		HE2		HE2	HE2	HE2	HE2	HE2		HE2
    Y		HH		HH	HOH	HH	HH	HH		HH
    Y		C		C		C	C	C	C	C
    Y		CA		CA		CA	CA	CA	CA	CA
    Y		CB		CB		CB	CB	CB	CB	CB
    Y		CG		CG		CG	CG	CG	CG	CG
    Y		CD1		CD1		CD1	CD1	CD1	CD1	CD1
    Y		CD2		CD2		CD2	CD2	CD2	CD2	CD2
    Y		CE1		CE1		CE1	CE1	CE1	CE1	CE1
    Y		CE2		CE2		CE2	CE2	CE2	CE2	CE2
    Y		CZ		CZ		CZ	CZ	CZ	CZ	CZ
    Y		N		N		N	N	N	N	N
    Y		O		O		O	O	O	O	O
    Y		OH		OH		OH	OH	OH	OH	OH

    V		H		H	HN	HN	HN	H		HN
    V		HA		HA	HA	HA	HA	HA		HA
    V		HB		HB	HB	HB	HB	HB		HB
    V		HG11		1HG1	HG11	HG21	HG11	HG11		HG11
    V		HG12		2HG1	HG12	HG22	HG12	HG12		HG12
    V		HG13		3HG1	HG13	HG23	HG13	HG13		HG13
    V		HG21		1HG2	HG21	HG11	HG21	HG21		HG21
    V		HG22		2HG2	HG22	HG12	HG22	HG22		HG22
    V		HG23		3HG2	HG23	HG13	HG23	HG23		HG23
    V		C		C		C	C	C	C	C
    V		CA		CA		CA	CA	CA	CA	CA
    V		CB		CB		CB	CB	CB	CB	CB
    V		CG1	pro-R	CG1		CG2	CG1	CG1	CG1	CG1
    V		CG2	pro-S	CG2		CG1	CG2	CG2	CG2	CG2
    V		N		N		N	N	N	N	N
    V		O		O		O	O	O	O	O

