################################################################
Progesteron Receptor
################################################################


***********
Objective
***********

To explore the protein-ligand conformational space around the binding site. Useful to refine docking

**************
Preparation
**************

To start the simulation, we need the complex.pdb an the input.yaml

Receptor
==========

Process the protein complex (PDB id: XXXX) with Protein Preparation Wizard (Schrodinger Program Suite) at pH 7.4 ± 0.5 to assign the protonation state to all ionizable residue as well as optimize the H-bond network. (Already done)


********************************************
Procedure: Induced fit
********************************************

Main characteristics of the simulation
========================================

- Induced fit simulation
- Inversely proportional strategy
- Computational time: 4h
- Cpus: 64

Control File Specifics
==========================

.. code-block:: yaml

    system: 'PR_1A28_xray_-_minimized.pdb'
    chain: 'Z'
    resname: 'STR'
    seed: 12345
    induced_fit_fast: true
    cpus: 64

Launch Command
==================

python -m pele_platform.main input.yaml


