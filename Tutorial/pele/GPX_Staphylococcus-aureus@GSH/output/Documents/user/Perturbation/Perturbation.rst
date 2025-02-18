.. _sec-perturbation:

Perturbation Block in Pele++ control file
=========================================

.. warning::

  You can skip the ligand perturbation phase in your PELE simulation by not including the ``"Perturbation"`` block in your simulation. However, if you do so, remember not to include any configuration related to it (such as a BindingEnergy metric), and also remember that the default values for some options (such as the links to be considered in the side chain prediction phase) may differ, causing that you simulation may not start or even work differently as you expect.


Example
-------

.. code-block:: json

    "Perturbation": {
        "perturbationType": "naive",
        "rotationAngles": "nonCoupled",
        "translationDirection": "steered",
        "translationRangeType": "spherical",
        "parameters": {
            "numberOfStericTrials": 200,
            "numberOfTrials": 5,
            "translationRange": 1.75,
            "rotationScalingFactor": 0.1,
            "rotationMidrangeFactor": 0.25,
            "streeringUpdateFrequency": 5,
            "overlapFactor":0.5
        }
    }

How perturbation of the ligand works
------------------------------------

The perturbation block controls the perturbation of the ligand. The ligand, formed by a rigid core (at least one atom) and a set of side chains, is perturbed by translating and rotating it, relieving any existing clash that may appear ([borrelli:2010]_). PELE creates a list of perturbation poses (typically configured to be between 1 and 20; see :ref:`sec-perturbation-parameters-numberOfTrials`), and then chooses the one with the lowest system energy. Each perturbation pose is generated through a random procedure, where a number of translations and rotations are tried (see :ref:`sec-perturbation-parameters-numberOfStericTrials`), until a combination is found that doesn't show any steric clashes after the clash relieving process. To allow the macromolecule to adapt to the new ligand position, clashes of up to 30% of the van der Waals interatomic distance between atoms are allowed (see :ref:`sec-perturbation-parameters-overlapFactor`), since the relaxation phase will probably relieve them. When searching the binding site, large translations are tried (around :math:`6 \AA{}`), while once in the binding site, small adjusments of less than :math:`1 \AA{}` are used (see :ref:`sec-perturbation-parameters-translationRange`). In addition, to allow the sampling of rare events, it is possible to force the translational vector to follow a randomly selected direction (what would be a steering vector) a given number of simulation steps, giving room to some small deviations (within :math:`10^{\circ}` to :math:`30^{\circ}`); in case of not finding a non-clashing translation, or after the round is finished, the steering vector is changed by a new one (see :ref:`sec-perturbation-steering`). Also, for those simulations that require exploring a restricted volume of the search space (as it is done in binding pose refinement), all ligand perturbations that place the ligand center of mass outside a predefined box are rejected (see :ref:`sec-boxes`).

The clash relieving process consists of trying different conformations on the flexible side chains of the ligand and macromolecule. If a clash exists between the cores of the ligand and receptor, then the pose is discarded. Otherwise, while there exists any clash around the ligand, a clashing residue (or the ligand) is randomly chosen, and a new conformation for its side chains is tried.

The time of a perturbation can vary depending on the number of rotable bonds and the resolution. To avoid large computational times, and even not having the amount of memory needed to perform a big number of combinations, PELE automatically does a random combination of the rotable bonds.

When you create a LIG.rot.assign file (see :ref:`sec-molecularParameters`), PELE has the following criteria to select the rotatable bonds **in each group**:

-  If there are less or equal than **3** rotatable bonds, all of them will be selected to rotate regardless of the resolution.
  -  If there are more than 3 rotatable bonds, and if it exists any resolution lower than :math:`30^{\circ}`, the maximum number or rotatable bonds to rotate in each steric try will be **3**.
-  If all resolutions are :math:`30^{\circ}` or higher, the maximum number or rotatable bonds to rotate in each steric try will be **5**.

The probability of selection will vary, being the inner ones more likely to be selected than the outer ones. 
Right now, the values of the weights are asigned to each rotamer bond, starting from 10 in the most inner bond, and descending from 1 to 1 until the last one. If it has more than 10 rotatable bonds, the last ones will be keep with weight 1.

For example, given this case of an oleic acid:

::

  rot assign res OLC &
    sidelib FREE30 _C9_ _C8_	
    sidelib FREE30 _C8_ _C7_ &
    sidelib FREE30 _C7_ _C6_ &
    sidelib FREE30 _C6_ _C5_ &
    sidelib FREE30 _C5_ _C4_ &
    sidelib FREE30 _C4_ _C3_ &
    sidelib FREE30 _C3_ _C2_ &
    sidelib FREE30 _C2_ _C1_ &
      newgrp &
    sidelib FREE30 _C10 _C11 &
    sidelib FREE30 _C11 _C12 &
    sidelib FREE30 _C12 _C13 &
    sidelib FREE10 _C13 _C14 &
    sidelib FREE30 _C14 _C15 &
    sidelib FREE30 _C15 _C16 &
    sidelib FREE30 _C16 _C17 &

In this case, the first group will have 5 random rotatable bonds, and in the second one, 3.
In the first group, the weight distribution for _C9_ _C8_ would be 10, for _C8_ _C7_ 9, until reaching _C2_ _C1_ with 3.

To configure the type of perturbation to perform, check :ref:`sec-perturbation-perturbationSelection` and :ref:`sec-perturbation-parameters`.

How to do Protein-Protein perturbation
--------------------------------------

As you can select a list of atomsets to perturb, PELE will perturb only one in each pele step,  iterating over all of them as the simualtion goes on.
This is not ideal if you want to perform a protein-protein simulation, as one of the protein will be moved, and if the system has metals or non-covalent
ligands, those will remain in place, causing clashes and problems. In order to fix this, you need to set up in the parameters of the pertrubation the flag
:ref:`sec-perturbation-parameters-perturbAllAtOnce`.  

.. _sec-side_chain_perturbation:

Side Chain Perturbation Block in Pele++ control file
====================================================


Example
-------

.. code-block:: json

    "SideChainPerturbation": {
        "sideChainsToPerturb": { "links": {"ids": ["A:145"] } },
            "parameters":{                                      
                    "overlapFactor": 0.5,                                         
                    "numberOfTrials": 20,                        
                    "atLeastOneSelectedTrial": true,
                    "maxTrialsForAtLeastOne": 50,
                    "refinementAngle": 10
            }     
    }

    
The side chain perturbation can be performed to perturb any sidechain in the protein. This was though to perform perturbations of a covalent ligand. As contrary as the standard perturbation,
in this algorithm, clashes with side chains will be ignored. This will allow the desired side chain to push the neigbours side chains, perturbing the system. Also, since a side chain
cant have a translation and rotation, there is no use of steric trials. Every trial will be a random pose of the side chain.

The refinement angle is an optional parameter. If it is enabled, the side chain perturbation will perform a very soft perturbation of a random angle between [-refinementAngle, +refinementAngle]
on the previous geometrical situation of the side chain to all the rotamers, so the side chain will have very little movements. This is ideal if you want to explore better an already found minima. 
This is not expected to work properly with high angles.

The rest of the parameters works exactly in the same way than in the standard perturbation.

.. _sec-perturbation-steering:

Steering
--------

Through the :ref:`sec-perturbation-perturbationSelection-translationDirection` option you can control whether to activate steering or not. Even when the steering is active, you can temporarily deactivate it by setting the update frequency to zero (:ref:`sec-perturbation-parameters-steeringUpdateFrequency`).

There are two kinds of steering, and they can be configured through :ref:`sec-perturbation-parameters-steeringMode`.

A steering cycle spreads through the perturbation phases of several PELE steps, consisting of ``steeringUpdateFrequency`` steps (see :ref:`sec-perturbation-parameters-steeringUpdateFrequency`). A steering vector is selected in each cycle, and all translations during that cycle will be based on that steering vector, with a Gaussian dispersion. After a steering cycle ends, a new steering vector is selected.

The ``random`` steering mode, selects a random steering vector before starting a new steering cycle. The ``best`` steering mode, selects as steering vector the translation vector of the perturbation selected in the first iteration of the steering cycle (therefore, the steering vector will be applied only during the next iterations in this case).

Notice that when using the ``proximityDistance`` option (:ref:`sec-peleParameters-proximityDistance`), if the ligand is far, the perturbation during that step will not use a steering vector, and a new steering cycle will start in the next PELE step.

If you change the ``steeringUpdateFrequency`` or the ``steeringMode`` to a different value during the simulation (see :ref:`sec-parametersThatCanChange`), a new steering cycle starts. Also, if during a steering cycle, while generating a particular perturbation (for a maximum of ``numberOfStericTrials``), the ligand always goes out of the configured box, then the steering vector is considered to get nowhere, and a new steering cycle is considered to have started (which implies selecting new steering vectors).


.. _sec-perturbation-perturbationSelection:

Perturbation selection
----------------------

.. _sec-perturbation-perturbationSelection-perturbationType:

perturbationType
^^^^^^^^^^^^^^^^

Use: It selects the ligand perturbation that is going to be used.

Possible values:

-  "naive": Selects the best ligand conformation (i.e. the one with
   lowest energy) of a certain number of random movements.
-  "metropolis": The ligand performs a random walk using the Metropolis
   algorithm.

Default value: No default value. You must indicate it.

.. _sec-perturbation-perturbationSelection-translationDirection:

translationDirection
^^^^^^^^^^^^^^^^^^^^

Parameter: TranslationDirectionGenerator \*
translationDirectionGenerator

Use: Selects the translation direction generation.

Note for developers: Used in AtomSetMover.

Possible values:

-  "random": Chooses a complete random direction.
-  "steered": Chooses a direction with a Gaussian dispersion with
   respect to the steering vector. The steering vector is updated
   according to the "steeringUpdateFrequency".

Default value: "random"

Plop info:

-  Plop control file name: steered
-  Plop parameter name: liga\_lig%steered
-  Plop default value: 0

translationRangeType
^^^^^^^^^^^^^^^^^^^^

Use: Select how to generate the translation vector modules using the
"translationRange".

Possible values:

-  "spherical": The translation vector is allowed to be inside a sphere
   centered in the perturbed atom set. That is, the vector modulus is
   drawn from a uniform distribution in [0,"translationRange"].

-  "centered": The translation vector modulus is drawn from a uniform
   distribution centered on "translatinRange", [0.75 \*
   "translationRange", 1.25 \* "translationRange"].

Default value: "centered"

Plop info: There is no equivalence in Plop

rotationAngles
^^^^^^^^^^^^^^

There are two options to generate the rotation angles using the
rotationScalingFactor.

Default value: "nonCoupled"

-  coupled: The same rotationScalingFactor is used for every angle.

    - :math:`\phi = \text{rotationScalingFactor} * \text{rand}(-2\pi, 2\pi)`

    - :math:`\psi = \text{rotationScalingFactor} * \text{rand}(-2\pi, 2\pi)`

    - :math:`\theta = \text{rotationScalingFactor} * \text{rand}(-\pi, \pi)`

where :math:`\phi`, :math:`\psi`, and :math:`\theta` are the rotation angles and :math:`\text{rand}(a,b)` is a random
number in the interval between brackets.

-  nonCoupled: Randomly, rotationScalingFactor is assigned to either 1,
   2 or 3 angles at random. For the rest, a rotationScalingFactor of
   0.02 is assigned. The angle is computed as follows: for a target
   angle :math:`\text{TA} = \text{FAR} * \text{rotationScalingFactor}`, :math:`\text{angle} = \text{sign}(\text{rand}) * \text{rand}((1-\text{RRF})*\text{TA}, (1+\text{RRF}) * \text{TA})`, where FAR (full angle range) is :math:`2\pi` for
   :math:`\phi` and :math:`\psi`, and :math:`\pi` for :math:`\theta`, and RRF is the rotationRangeFactor.

.. _sec-perturbation-parameters:

Parameters
----------

numberOfSteps
^^^^^^^^^^^^^

Parameter: unsigned int numberOfSteps

Use: Number of steps in the 'metropolis' algorithm.

Note for developers: Used in LigandPerturbationMetropolis::perturbLigand

Range: An integer in [1,inf).

Units: Dimensionless.

Default value: 1000.

Plop info: There is no equivalence in Plop

.. _sec-perturbation-parameters-numberOfTrials:

numberOfTrials
^^^^^^^^^^^^^^

Parameter: unsigned int numberOfTrials.

Use: Number of iterations in the 'naive' algorithm.

Note for developers: Used in LigandPerturbationNaive::perturbLigand.

Range: An integer in [1,inf).

Units: Dimensionless.

Default value: 10

Plop info:

-  Plop control file name: 'tries'
-  Plop parameter name: liga\_params%tries
-  Plop default value: 1

.. _sec-perturbation-parameters-numberOfStericTrials:

numberOfStericTrials
^^^^^^^^^^^^^^^^^^^^

Parameter: unsigned int numberOfStericTries.

Use: Number of tries to get a non-clashing conformation for each trial
in 'numberOfTrials'.

Note for developers: Used in LigandPerturbationNaive::perturbLigand.

Range: An integer in [1,inf).

Units: Dimensionless.

Default value: 500

Plop info:

-  Plop control file name: 'steric\_tr'
-  Plop parameter name: liga\_params%max\_steric\_tries
-  Plop default value: 1000

atLeastOneSelectedTrial
^^^^^^^^^^^^^^^^^^^^^^^

Parameter: boolean atLeastOneSelectedTrial.

Use: Whether to do the perturbation phase to last until, at least, one
trial has been selected. However, at most maxTrialsForAtLeastOne trials
would ever be done.

Default value: false

Plop info: There is no equivalence in Plop.

maxTrialsForAtLeastOne
^^^^^^^^^^^^^^^^^^^^^^

Parameter: unsigned int numberOfStericTries.

Use: Only considered if atLeastOneSelectedTrial is true. In such a case,
it is the maximum number of iterations/steps done in the perturbation.

Range: An integer in [1,inf).

Units: Dimensionless.

Default value: 1000

Plop info: There is no equivalence in Plop.

rotationScalingFactor
^^^^^^^^^^^^^^^^^^^^^

Parameter: double rotationScalingFactor.

Use: Factor used to generate the rotation angles.

Note for developers: Used in LigandPerturbation::rotateRandomly.

Range: [0, 0.5]

Units: Dimensionless.

Default value: 0.5

Plop info:

-  Plop control file name: 'rot\_r'
-  Plop parameter name: liga\_params%rot\_range
-  Plop default value: 0

rotationRangeFactor
^^^^^^^^^^^^^^^^^^^

Parameter: double rotationRangeFactor.

Use: Factor used to generate the range of allowed rotation angles. Given
a rotation angle target value TA, the allowed range of angles will be
[(1-RRF)*TA, (1+RRF)*\ TA)], being RRF the rotationRangeFactor.

Note for developers: Used in LigandPerturbation::rotateRandomly.

Range: [0, 1.0]

Units: Dimensionless.

Default value: 0.25

Plop info: There is no equivalence in Plop.

.. _sec-perturbation-parameters-translationRange:

translationRange
^^^^^^^^^^^^^^^^

Parameter: double translationRange.

Use: Factor in the length of the random translation.

:math:`\text{shift} = \text{translationRange} * \text{rand}(1,2)`

Note for developers: Used in LigandPerturbation::translateRandomly.

Range: (0,inf)

Units: :math:`\AA{}`

Default value: 1

Plop info:

-  Plop control file name: 'tra\_r'
-  Plop parameter name: liga\_params%tr\_range
-  Plop default value: 0

.. _sec-perturbation-parameters-overlapFactor:

overlapFactor
^^^^^^^^^^^^^

Parameter: double overlapFactor.

Use: See side chain section for more information.

Note for developers: Used to find and relieve ligand side chain clashes
in ClashesReliever and Perturbation.

Range: [0,inf)

Units: Dimensionless.

Default value: 0.6

Plop info: Plop uses the same overlap factor that uses for the proteins.

-  Plop control file name: 'ofac\_min'
-  Plop parameter name: side\_params%tree\_params%ofac\_min
-  Plop default value: 0.7

temperature
^^^^^^^^^^^

Parameter: double temperature.

Use: Used in the acceptance criterion in the ligand perturbation
Metropolis algorithm.

Note for developers: Used in
LigandPerturbationMetropolis::perturbLigand.

Range: (0,inf)

Units: K

Default value: 200000 (this makes for a 0.5 probability of accepting
energies about 275 kcal/mol higher)

Plop info: There is no equivalence in Plop.

.. _sec-perturbation-parameters-steeringMode:

steeringMode
^^^^^^^^^^^^

Parameter: string steeringMode

Use: It selects how the steering vector is calculated.

Possible values:

- ``"random"``: A random translation vector is selected as the steering vector in the first iteration of each steering cycle, and that vector is used during that iteration and in all later iterations of the steering cycle.
- ``"best"``: First iteration of each steering cycle doesn't impose any restriction to the translation direction. After the best perturbation is chosen, its translation vector is selected as the steering vector, and subsequent iterations in the steering cycle will use that vector.

Default value: ``"random"``.

.. _sec-perturbation-parameters-steeringUpdateFrequency:

steeringUpdateFrequency
^^^^^^^^^^^^^^^^^^^^^^^

Parameter: unsigned int steeringVectorUpdateFrequency

Use: If steering, frequency to update the steering direction. If it is
set to 0, then steering is deactivated and a random translation
direction is used, until this parameter is changed again to a value
greater than 0.

If this parameter is modified using the parametersChanges option, and
the new value is the same as before, then simulation continues as if
this parameter had not been changed (that is, if there remained two
steps for updating the steering vector, there still remain those two
steps).

Note for developers: Used in the translation direction generation.

Range: (0,inf)

Units: Dimensionless

Default value: 2

Plop info:

-  Plop control file name: waitfor
-  Plop parameter name: liga\_params%wait
-  Plop default value: 1

gridResolution
^^^^^^^^^^^^^^

Parameter: double gridResolution

Use: Resolution of the rotamer library to be used for the 'non-polar'
part of non-ligand links (the polar part always uses the resolution
given in the link-type rotamer library file for the polar atom) when
relieving clashes in the perturbation. Ligand links always use the
resolution stated in the rotamer library file for that link; therefore
this parameter does not affect them. The angles a rotamer can take are
divided in bins of length 'gridResolution' degrees.

Units: Degrees

Range: It can take any value, generally 10, 20, 30, 40 (these are the
only values allowed for standard protein residues). If an unsupported
resolution is chosen, it is set to the base resolution for each type of
link, which is 10 in the standard protein residues.

Default value: 10

Plop info: ??


.. _sec-perturbation-parameters-perturbAllAtOnce:

perturbAllAtOnce
^^^^^^^^^^^^^^

Parameter: float perturbAllAtOnce

Use: Makes pele to perturb all selected atom sets at once in the same pele step.

Units: Dimensionless

Range: true or false

Default value: false


Boxes
-----

See :ref:`box <sec-boxes>`.

