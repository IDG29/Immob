.. _sec-interactionRestrictions:

Interaction Restrictions in Pele++ control file
===============================================

This page documents the interaction restrictions functionality of Pele++.

This functionality jumps to the next PELE step iteration and skips the final Minimization algorithm if the current perturbed pose of the ligand is detected as non interesting.

Then, in a biased exploration, we can skip those non interesting poses and only spend time on minimizing the interesting ones for our particular study.

To distinguish between interesting and non interesting poses we need to define the :ref:`conditions <sec-conditionsByExample>` required for the current exploration.


Conditions
-----------

If all
:ref:`conditions <sec-conditionsByExample>` are met,
the current pose will be minimized and evaluated using Metropolis criterium.


.. note::

  The conditions are related to metrics already define in :ref:`metrics block <sec-metricTypes>`.


Example1
--------

.. code-block:: json

    "interactionRestrictions":
    [
            "bdistance < 4",
            "h-bondAngle > 90",
            "h-bondAngle < 180"
    ]

In this first example, we show a configuration with three restrictions. All of them must be true to mimimize the current pose.

Example2
--------

.. code-block:: json

    "interactionRestrictions":
    [
            "bdistance < 4"
    ]

In this second example, we show a configuration with a single restriction, which must be true to minimize the current pose.
