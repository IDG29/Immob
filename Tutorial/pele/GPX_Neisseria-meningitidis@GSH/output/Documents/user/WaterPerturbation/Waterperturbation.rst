.. _sec-water:

Water Perturbation Block in Pele++ control file
=====================================================

This block configures the Water Perturbation in a ``peleSimulation``
command. In a ``peleSimulation``, this phase will be active depending
whether the ``WaterPerturbation`` block is present or not. If defined,
an extra MC perturbation step focused on explicit water molecules will
be performed after the ligand perturbation. This consists in a
stochastic translation and rotation of the water molecules to a steric
free location followed by a local minimization step. The new
conformation is only accepted if it fulfills the Metropolis criterion.
The user can decide whether to move a single water molecules or more
than one by defining them explicitly in the control file. In order to
assess how many water molecules to use we are currently building a new
methodology.

It is also possible to defined different water sites and associate a
certain set of explicit water molecules and boxes to each. Those water
molecules defined in a water site will be explored within the box that
corresponds to that water site. Those water molecules that need to be
perturbed but are not included in a water site will be perturbed within
the general box of water perturbation, if any is defined. In case there
is not a general box defined, they will be perturbed in an infinite
box (no box will be applied to them).

Note that the frequency with which this algorithm is performed in a Pele
simulation can be set in the PeleParameters section of the control file.
See more information about this parameter at :ref:`sec-peleParameters-waterPerturbationFrequency`.

In case of questions or problems regarding the Water Perturbation algorithm
contact the author at marti.municoy@bsc.es.

Example
--------

The WaterPerturbation block can be defined inside the pele simulation
command block section as next. In this case, a perturbation on four
different water molecules is defined. However, at each Pele step, only
to of them will be perturbed (see :ref:`sec-waterperturbation-watersToPerturbPerStep`
command below). In this example, water molecules are perturbed at three
different cavities: one is defined through the general box of the water
perturbation algorithm and the other two through the definition of two
water sites. In this way, W:4 wil be perturbed within the box defined
in the first water site, W:5 and W:6 will be perturbed within the box
of the second water site and W:7, since it has not been assigned to any
water site, will use the global box of water perturbation.

.. code-block:: json

    {
        "WaterPerturbation":
        {
            "Box" :
            {
                "radius" : 10,
                "fixedCenter": [28.02, 5.97, 19.16],
                "type" : "sphericalBox"
            },
            "watersToPerturb":  { "links": { "ids": [ "W:4", "W:5", "W:6", "W:7" ] } },
            "parameters":
            {
                "watersToPerturbPerStep": 2,
                "translationRange": 2
            },
            "waterSites":
            [
                {
                    "watersToPerturb": {"links": {"ids": ["W:4"] }},
                    "Box": {"radius": 5, "fixedCenter": [25.48, 11.49, 18.06], "type": "sphericalBox"}
                },
                {
                     "watersToPerturb": {"links": {"ids": ["W:5", "W:6"] }},
                     "Box": {"radius": 6, "fixedCenter": [16, 6, 21], "type": "sphericalBox"}
                }
            ]
        }
    }


.. _sec-waterperturbation-Waterselection:

Global selection of waters to perturb
-------------------------------------

WaterPerturbation works on a set of selected water molecules. All water
molecules defined in the global selector will be perturbed inside the
global perturbation box (see :ref:`sec-waterperturbation-Box`).

Note that in case that one water molecule is also defined in a water
site (see :ref:`sec-waterperturbation-waterSites` for more information),
the box of that site would always have precedence over the global box
as long as it is a finite spherical box.

.. code-block:: json

    {
        "watersToPerturb": { "links": { "ids": [ "W:1" ] } }
    }


- Parameter: ``watersToPerturb``
- Type: Pele links selection (see more details at :ref:`sec-selectionExamples`)


.. _sec-waterperturbation-Box:

Global box
----------

It is always recommended to define a global box for the perturbation algorithm.
In this way, explicit water molecules would be perturbed inside a specific region
as they could not get outside the perturbation box. If a global box is not
defined, water molecules would not have any spatial constrain and could be shifted
in any protein region indistinctly.

.. code-block:: json

    {
        "Box" :
        {
            "radius" : 10,
            "fixedCenter": [28.02, 5.97, 19.16],
            "type" : "sphericalBox"
        }
    }


- Parameter: ``Box``
- Type: Pele box definition (see more details at :ref:`sec-boxes`)


.. _sec-waterperturbation-waterSites:

waterSites
----------

Several boxes can be associated to specific water molecules through water sites.
In this way, the user can choose to perturb some water molecules inside one
region and some others in a different region. Each water site can have their
own box settings.

Note that if those water molecules that are selected to perturb
do not have any water site specified will be perturbed using the global
box of the algorithm, if any. In case that no global box is defined, their
perturbation will not be restricted inside a box.

It is also worth to mention that if a water molecule belongs to a water site and
has also been selected globally, the box from the water site will have precedence
(unless it is an infinite box) over the global perturbation box..

It is always recommended to define a global box for the perturbation algorithm.
In this way, explicit water molecules are perturbed inside a specific region
as they cannot get outside the perturbation box.

.. code-block:: json

    {
        "waterSites":
        [
            {
                "watersToPerturb": {"links": {"ids": ["W:4"] }},
                "Box": {"radius": 5, "fixedCenter": [25.48, 11.49, 18.06], "type": "sphericalBox"}
            },
            {
                 "watersToPerturb": {"links": {"ids": ["W:5", "W:6"] }},
                 "Box": {"radius": 6, "fixedCenter": [16, 6, 21], "type": "sphericalBox"}
            }
        ]
    }


- Parameter: ``waterSites``
- Type: list of water site definitions. Each water site requires the definition of a set of water molecules, ``watersToPerturb``,  and a perturbation box, ``Box``.


watersToPerturb
^^^^^^^^^^^^^^^

Selection of the explicit water molecules of each water site.

- Parameter: ``watersToPerturb``
- Type: Pele links selection (see more details at :ref:`sec-selectionExamples`)


Box
^^^

Definition of the perturbation box of each water site.

- Parameter: ``Box``
- Type: Pele box definition (see more details at :ref:`sec-boxes`)


.. _sec-waterperturbation-Parameters:

Parameters
--------------

All the possible parameters that can be specified in this section are the following ones:

.. code-block:: json

    {
        "parameters":
        {
            "translationRange" : 5.0,
            "overlapFactor" : 0.8,
            "temperature": 500,
            "numberOfStericTrials": 1000,
            "COMConstraintConstant": 0.2,
            "watersToPerturbPerStep": 2
        }
    }



.. _sec-waterperturbation-translationRange:

translationRange
^^^^^^^^^^^^^^^^^^

WaterPerturbation works by translating and minimazing the water molecule
at each PELE step. The translation range of the water molecules can be define with
this parameter. However, the final translation modulus is allowed to fluctuate at
each move trial to expand the sampling capabilities. It is obtained by applying
the following equation:

:math:`\text{Translation modulus} = \text{random double between}(0.75, 1.25) * \text{translationRange}`


- Parameter: ``translationRange``
- Type: float
- Default: 5.0
- Units: angstroms
- Range: (0, inf)


.. _sec-waterperturbation-overlapFactor:

overlapFactor
^^^^^^^^^^^^^^^^^^

The overlap factor that is used when looking for initial cavities for perturbed
water molecules without steric clashes. When this factor gets lower, a higher steric overlap
is accepted. See :ref:`sec-sideChainPrediction-parameters-overlapfactor`
for more information about this parameter.


- Parameter: ``overlapFactor``
- Type: float
- Default: 0.8
- Units: dimensionless
- Range: [0, 1]


.. _sec-waterperturbation-temperature:

temperature
^^^^^^^^^^^^^^^^^^

The temperature that is used in the Metropolis criterion to decide whether to accept
the new location of a perturbed water or not. The higher the temperature is, the
easier will be to accept new water locations. Thus, more locations will be explored
but worse conformations will be generated.


- Parameter: ``temperature``
- Type: float
- Default: 1000
- Units: Kelvin degrees
- Range: (0, inf)


.. _sec-waterperturbation-numberOfStericTrials:

numberOfStericTrials
^^^^^^^^^^^^^^^^^^^^^

Number of trials that will be performed to look for steric-clashes-free
cavities for the perturbed water molecules. For small pockets were
valid movements are hardly found, you can consider increasing the amount
of trials. See :ref:`sec-perturbation-parameters-numberOfStericTrials`
for more details.


- Parameter: ``numberOfStericTrials``
- Type: integer
- Default: 1000
- Units: dimensionless
- Range: [1, inf)


.. _sec-waterperturbation-COMConstraintConstant:

COMConstraintConstant
^^^^^^^^^^^^^^^^^^^^^^^

Constraint on the center of mass (COM) of each atomset that will be applied
on all water molecules that are perturbed, once they are in the new location.
Thus, during the relaxation step, perturbed water molecules will not be able
to move to other places. This parameter could benefit the exploration of new
water sites. However, as it introduces more constraints to the system, the
final acceptance at the end of the Pele step could be lowered significantly.


- Parameter: ``COMConstraintConstant``
- Type: float
- Default: 0.0
- Units: :math:`\text{kcal}/(\text{mol} \cdot \unicode{xC5}^{2})`
- Range: [0, inf)


.. _sec-waterperturbation-watersToPerturbPerStep:

watersToPerturbPerStep
^^^^^^^^^^^^^^^^^^^^^^

Maximum number of water molecules that will be perturbed in a single water
perturbation step. The default value, which is -1, perturbs all the water
molecules that were selected in the WaterPerturbation section of the
control file.

- Parameter: ``watersToPerturbPerStep``
- Type: integer
- Default: -1
- Units: dimensionless
- Range [-1, inf)


.. _sec-waterperturbation-allowEmptyWaterSelectors:

allowEmptyWaterSelectors
^^^^^^^^^^^^^^^^^^^^^^

This flag prevents the algorithm to fail when one water molecule selected in the control file is not found in the current structure. In this way, when set to true, the algorithm will skip any selected water molecule that is missing in the complex.

- Parameter: ``allowEmptyWaterSelectors``
- Type: boolean
- Default: false
