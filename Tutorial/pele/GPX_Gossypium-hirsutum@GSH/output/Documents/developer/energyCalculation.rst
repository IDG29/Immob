.. _sec-dev-energyCalculation:

******************
Energy calculation
******************

1-4 terms
=========
As seen in ``Topology::generate14List()``, the list of 1-4 terms is created 
from the list of dihedrals that comes in the template files. However, not all
dihedrals there are included, but only those that do not have any negative sign
in front of the index number of some of their atoms. It is probable that this
exclusion is due to the consideration of the interaction forces between those
atoms already in other 1-4 terms. Actually, the dihedrals having atoms with 
negative signs seem to share the same initial indexes (including the one with
the negative sign) with other dihedrals.

