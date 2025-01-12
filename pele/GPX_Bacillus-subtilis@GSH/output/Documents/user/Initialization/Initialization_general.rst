.. _sec-initialization-general:

General description
===================

Location
--------

Outermost layer, typically at the beginning of the document.

Example:

.. code-block:: json

   {
      "Initialization" : {
	     "fixTrees": true,
   	     "fixChainNames": false,
         "allowMissingTerminals": false,
         "Complex" : {
            "files" : [
               {
                  "path": "pdbs/ain_fixed.pdb"
               }
            ]
         },
         "ForceField" : "OPLS2005",
         "Solvent" : {
            "ionicStrength" : 0.250,
            "solventType" : "VDGBNP",
            "useDebyeLength" : true
         }
      },
      "commands" : [ ... ]
   }

Options and parameters
----------------------

fixTrees
^^^^^^^^

Use: Bolean. When it is set to true, for any complex being built,
it builds the trees equal to Plop.

Note for developers: Used in generateAtomsTrees

Default value: true

fixChainNames
^^^^^^^^^^^^^

Use: Boolean. When true, for any complex being built,
it renames all chains starting at 'A' through 'Z' and then '1' through '0'.

Notice that if you have many molecules (such as water molecules) you may
run out of chain identifiers. In such a case, chain ids will get reused
(it will restart from 'A' again).

Note for developers: Used in
ComplexBuilder::createComplexBuilder.

Default value: false

.. _sec-initialization-general-allowMissingTerminals:

allowMissingTerminals
^^^^^^^^^^^^^^^^^^^^^

Use: Boolean. When true, when reading a complex, if a terminal residue in a chain does not have the atoms of the terminal type for that residue, then it is treated as a normal internal/middle residue. If this does not work either, then PELE fails as usual, since it is not able to assign the right template. Notice that this is valid for any chain, though only proteins and nucleic acids actually have terminal types of residues.

This option is useful if you have gaps in your structure. In such a case, you mark the gaps with TER records, and instruct PELE to interpret the terminal residues at the gaps (which must not have terminal atoms such as OXT) as normal internal residues.

Notice that, being internal residues, they will be treated as such in all parts of PELE. For example, in the VDGBNP case, those residues will be treated as internal as for the dielectric assignment.

Default value: false


Complex
^^^^^^^

See :ref:`Complex <sec-complex>`

MultipleComplex
^^^^^^^^^^^^^^^

See
:ref:`AdditionalFeaturesUsingMPI <sec-additionalFeaturesUsingMPI>`


.. _sec-initialization-general-solvent:

Solvent
^^^^^^^

See :ref:`Solvent <sec-solvent>`

.. _sec-initialization-general-forcefield:

ForceField
^^^^^^^^^^

Parameter: enum PotentialParameterization

Use: Sets the force field to be used throughout the simulation

Note for developers: Used in SgbAlphaSasaUpdater,
NonBondingTermCalculator, EnergyAlgorithm and
BindingEnergyMetricsBuilder.

Note: The force field parameter files are found under :file:`Data/Templates/`

Possible options:

-  "OPLS2005"

-  "AMBER99sb" (not thouroghly tested in production, but it should work)

-  "AMBER99" (not thoroughly tested in production, but it should work)

-  "AMBER99sbBSC0"

-  :ref:`"OpenForceField" <sec-initialization-general-openforcefield>` (in beta stage)

Defalut value: None, it must be specified

Plop info: No correspondence, it just uses OPLS2005.


.. _sec-initialization-general-useGPU:

useGPU
^^^^^^

Use: Boolean that enables the use of GPUs. We remind that its in an
experimental stage.


.. _sec-initialization-general-openforcefield:

Open Force Field
----------------

.. warning::
   Please, note that the current Open Force Field implementation in PELE is in beta stage. Its validation is still under revision and it is very susceptible to change.

`The Open Force Field initiative <openforcefield.org>`_ is an open source approach towards the development of better force fields. The idea behing their force fields is to skip atom types and work with a direct chemical perception by considering standard chemical substructures through `SMARTS <https://www.daylight.com/dayhtml/doc/theory/theory.smarts.html>`_ and `SMIRKS <https://www.daylight.com/dayhtml/doc/theory/theory.smirks.html>`_ patterns. Thanks to their Python toolkit, we can parameterize small molecules using their force fields and the direct chemical perception technique. Besides, we plan to integrate a full protein force field in PELE in the future.

The current implementation of Open Force Field requires the following three files to account for the parameters of a single link:

- Link's rotamer library
- Link's parameters template
- Link's parameters template for the solvent (OBC)

All these files can be generated with the `offPELE Python package <https://github.com/martimunicoy/offPELE>`_.
