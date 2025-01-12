.. _sec-conformation-pert:

Conformation Perturbation Block in Pele++ control file
======================================================

This block configures the Conformation Perturbation in a ``peleSimulation``
command. In a ``peleSimulation``, this phase will be active depending 
whether the ``ConformationPerturbation`` block is present and whether a conformation
library for the ligand is present. If defined, an extra perturbation step 
focused on changing the conformation of the ligand will be performed after 
the ligand perturbation. This applies a translation to each atom with respect
to the root atom (the first atom in the template) as specified in the conformation 
library to adopt one of the conformations defined there. Afterwards, the PELE step 
will proceed as specified in the control file.
If no conformation can be applied due to clashes, the step will be rejected on
account of that, and the reason will be specified in the log file.

Note that the frequency with which this algorithm is performed in a Pele
simulation can be set in the PeleParameters section of the control file.
See more information about this parameter at :ref:`sec-peleParameters-conformationPerturbationFrequency`.

Conformation libraries
-------------------------
Conformation libraries used during conformation perturbation are located in the :file:`Data/` directory.

If you use non-standard molecules and residues not included in the data directories, then you should create and add the conformation library definition file in your :file:`DataLocal/` directory (at :file:`<DataLocal>/Conformations`).

More information about create conformation libraries files in :ref:`sec-molecularParameters-conformationLibrary`.

Example
--------

The ConformationPerturbation block can be defined inside the pele simulation
command block section. In this case, a perturbation with an overlapFactor of
0.65 is defined. At each Pele step, it will reproduce one of the conformations
specified in the conformation library until one without clashes is found.

.. code-block:: json

    {
        "ConformationPerturbation":
        {
            "parameters":
            {
                "overlapFactor": 0.65
            }
        }
    }


.. _sec-conformationperturbation-Parameters:

Parameters
--------------

All the possible parameters that can be specified in this section are the following ones:

.. code-block:: json

    {
        "parameters":
        {
                "overlapFactor": 0.65
        }
    }


.. _sec-conformationperturbation-overlapFactor:

overlapFactor
^^^^^^^^^^^^^^^^^^

The overlap factor that is used when looking for steric clashes of the resulting 
conformation. When this factor gets lower, a higher steric overlap
is accepted. See :ref:`sec-sideChainPrediction-parameters-overlapfactor`
for more information about this parameter.

- Parameter: ``overlapFactor``
- Type: float
- Default: 0.65
- Units: dimensionless
- Range: [0, 1]

