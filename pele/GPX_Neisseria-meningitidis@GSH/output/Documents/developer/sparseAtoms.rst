.. _sec-dev-sparseAtoms:

************
Sparse Atoms
************

Sparse atoms are used to represent the links they belong to, so that distance calculations can be more efficiently done.

Each link has a member variable ``sparseAtoms`` that contains all the sparse atoms for that link. This sparse atoms are used directly when calling:

- ``Link::minimumSquaredDistanceBetweenSparseAtoms()``
- ``Link::getSparseAtoms()``

These distance calculations are used for:

- Proximity detection at ``ProximityDetector::noLinkIsNearbyAnyInputLink()``.
- Determining the top energy changing links in Side Chain Prediction: ``DeltaEnergyTopSideLinksSelection::getAlsoNonDuplicatedNearByLinks()``.
- Calculating Pele Regions: ``PeleRegions::getAffectedLinks()``, including the perturbed set with ``InterfacePeleRegions::updatePerturbedLinks()``.
- Non-bonded list generation: ``NBGeneratorMultiscale::residuesSparseAtomsMinimumSquaredDistance()``. The sparse distance is used to classify interaction of two residues in INSIDE_SHORT_REGION, INSIDE_LONG_REGION or OUT_OF_INTEREST.

Generation of sparse atoms
==========================

The function that creates the vector of sparse atoms is ``SparseAtomsGenerator::generate()``, which is called for each link or, in the case of ligand links, for each of its sublinks. When generating sparse atoms, ideal distances (from the template files) are used. Sparse atoms are generated at ``ComplexBuilder::create()``.

The algorithm is:

- If the link has a single atom, then that atom is a sparse atom.
- Hydrogens of water molecules are never considered sparse atoms.
- It is an option to include hydrogens or not (though, in PELE, they are always considered).
- Consider all atoms (excep the previously excluded ones) as candidates, and iterate until there are no candidates left, selecting a sparse atom in each round, and discarding all those atoms in its excluded list (bonded, or forming an angle or dihedral), since they are represented by the sparse atom. At each iteration, among the candidate atoms, the ones that are closest (in number of bonds) to the root atom, or at most 2 more bonds further, are considered; from them, if one of the atoms is further than other candidates, and they are not in the excluded list of the other, the furthest one is discarded; finally, from the selected ones, the one with the most number of excluded atoms, or (in case of tie) the one further from root in number of bonds, or the one further in angstroms from the last sparse atom selected, or from a target atom (only if it is the first iteration; for amino acids, it is the CA atom, for nucleotides it is the C4' atom, and for ligands, it is its first atom) is chosen.

The idea in generating sparse atoms is to grab the atom closest to the link root atom, and consider it represents those in its exclusion list (those included in the bonded energy terms), discarding them. Continue until all the atoms in the link are either sparse atoms, or represented by them.

It is not clear the reason for this specific algorithm in generating the sparse atoms, though it will probably have the property of selecting small sets of sparse atoms in links while, at the same time, creating the right lists of neighbors and right list of links in the different regions calculated.

Sublinks
--------

In the case of ``LigandLink``, the link is divided into sublinks, the sparse atoms are calculated for each sublink, and they are finally put together as the sparse atoms of the link. Each sublink represents all the atoms in a ligand side chain, starting from the root atom of the ligand. This may cause that some atoms belong to several sublinks. If there are no side chains, there exists a single sublink that contains all atoms. For one or more side chains, the first side chain also adds all the core atoms of the ligand.
