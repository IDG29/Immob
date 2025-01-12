###################
Simulation
###################


Start your own simulation:
++++++++++++++++++++++++++++++

1)  Complex Preparation

Prepare the system with maestro (Protein Preparation Wizard, hydrogen optimization and posterior minimization) and output a complex.pdb.

Make sure the ligand has:

    - Unique chain

    - No atomnames with spaces or single letter

    - Any residuename except UNK


2) Prepare the input file input.yml

For more on the input files and the different types of simulation,
please, refere to `here <https://nostrumbiodiscovery.github.io/pele_platform/cheatsheet/index.html#input-preparation>`__


3) Run the simulation

python -m pele_platform.main input.yml

