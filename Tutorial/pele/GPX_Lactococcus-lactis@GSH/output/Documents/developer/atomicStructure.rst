.. _sec-dev-atomicStructure:

*******************************
Atomic Structure (AtomSet tree)
*******************************

This section describes how PELE represents internally the atomic structures, including the topology (bonds, angles, dihedrals and improper dihedrals), non-bonded relations, and the coordinates.

PELE++ describes a biochemical complex as a hierarchical tree of :ref:`AtomSet <sec-atomicStructure-atomSet>` objects: the AtomSet tree.

The tree can have up to 3 levels in the tree, and each level corresponds
to a different level of detail.

-  The first level corresponds to the :ref:`Complex <sec-atomicStructure-complex>`  which is the root of the
   tree. It's the coarser grain description and is comprised of all the
   :ref:`Chain <sec-atomicStructure-chain>` objects present in the simulation.

-  The second level is the :ref:`Chain <sec-atomicStructure-chain>` level. Every :ref:`Chain <sec-atomicStructure-chain>` represents a
   polymer.

-  The third level is the :ref:`Link <sec-atomicStructure-link>` level.

The tree is actually implemented throught the :ref:`Node <sec-atomicStructure-node>` class, while the ``AtomSet`` is a subclass of ``Node`` that adds atom-related functionality.

Design decisions related to this hierarchical model:

-  There are 3 and only 3 levels. This description is perfect for
   polymers but it might be less adequate when describing single
   molecules.

Implications of the model:

-  The total number of atoms of an :ref:`AtomSet <sec-atomicStructure-atomSet>` is the the summation of the
   total number of atoms of each of its children.
-  The Topology of an :ref:`AtomSet <sec-atomicStructure-atomSet>` will be the union of the topologies of
   each of its children.
-  For performance reasons, every :ref:`AtomSet <sec-atomicStructure-atomSet>` in the tree, independently of
   its level, has direct access to its own :ref:`Geometry <sec-atomicStructure-geometry>` and :ref:`Topology <sec-atomicStructure-topology>` and
   those of the :ref:`Complex <sec-atomicStructure-complex>`.

.. _sec-atomicStructure-node:

Node
====

This class is used to represent a tree in memory. The class represents the nodes of the tree, and contain information as to what siblings, parent, and children have the node. There is also functionality to directly get access to the top (*root*) of the tree.

.. _sec-atomicStructure-atomSet:

AtomSet
=======

It's a set of Atoms with Topology and Geometry so that it's energy (in
vacuum) can be computed.

It corresponds to an abstract class in Pele++ from which many important
classes inherit functionality that has to do, mainly, with Topology and
Geometry generation and manipulation.

The main AtomSet types are Complex, Chain and Link.

.. _sec-atomicStructure-chain:

Chain
=====

It's a set of Link objects linked by covalent bonds. There are four
types of Chain objects: ProteinChain (comprised of Residues), DNAChain
(comprised of Nucleotides), RNAChain (also comprised of Nucleotides) and
Ligand (comprised of LigandLinks).

.. _sec-atomicStructure-complex:

Complex
=======

A Complex is an entity comprised of one or more molecules that
corresponds to one or more PDB files. It correspond to a class in Pele++
that is a type of AtomSet, so it inherits all the functionality of an
AtomSet. What makes it special is that it is the root of the AtomSet
tree being its children Chain objects. Being the root of the AtomSet
tree, it plays the role of an access point for the rest of the Pele++
components to the whole Topology and Geometry information. It acts as a
façade (see `Façade pattern <http://en.wikipedia.org/wiki/Facade_pattern>`__) that hides all
the complexity of the Topology and Geometry storage and manipulation.
There is only one Complex in a simulation! [#f1]_.

.. _sec-atomicStructure-geometry:

Geometry
========

The Geometry manages the cartesian and internal coordinates of an
AtomSet. It mainly contains methods to update coordinates, to pass from
cartesian to internal coordinates and viceversa and methods to apply
rotamers to internal coordinates. There are three types of coordinates:
cartesian coordinates, direct internal coordinates and reverse internal
coordinates.

.. _sec-atomicStructure-link:

Link
====

It's a set of Atom objects linked by covalent bonds. There are three
types of Link objects: Residue, Nucleotide and LigandLink.

.. _sec-atomicStructure-topology:

Topology
========

The Topology holds and manages all the connection among Atoms that are
built when the Complex is created.

These connections include: Bonds, Angles, Dihedrals and 14 interactions.

Each AtomSet in the AtomSet tree has its own Topology that is in every
moment the result of the union of the Topologies of that AtomSet
children.

An AtomSet's Topology is also the union of two disjoint sets: the free
Topology and the frozen Topology. The frozen Topology is comprised of
all those connections among Atoms in which all Atoms happen to be
frozen, whereas the free Topology contains all those connections that
involve at least one free Atom.

.. rubric:: Footnotes

.. [#f1] Actually, to compute the BindingEnergy metric two other partial
   Complex objects must be created, one corresponding to the Ligand in
   isolation and the other corresponding to the rest of the system in
   isolation.

