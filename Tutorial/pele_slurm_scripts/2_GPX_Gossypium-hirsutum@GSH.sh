#!/bin/bash
#SBATCH --job-name=2_GPX_Gossypium-hirsutum@GSH
#SBATCH --qos=bsc_ls
#SBATCH --time=48:0:00
#SBATCH --ntasks 96
#SBATCH --output=2_GPX_Gossypium-hirsutum@GSH_%a_%A.out
#SBATCH --error=2_GPX_Gossypium-hirsutum@GSH_%a_%A.err

module purge
module load anaconda
module load intel
module load impi
module load mkl
module load boost
module load cmake
module load transfer
module load bsc

eval "$(conda shell.bash hook)"
source activate /gpfs/projects/bsc72/conda_envs/platform

export PELE_EXEC=/gpfs/projects/bsc72/PELE++/nord4/V1.8/bin/PELE-1.8
export SCHRODINGER=/gpfs/projects/bsc72/MN4/bsc72/SCHRODINGER_ACADEMIC_NORD

cd pele/GPX_Gossypium-hirsutum@GSH
python -m pele_platform.main input.yaml
python ../._correctPositionalConstraints.py output output/input/GPX_Gossypium-hirsutum@GSH@6_processed.pdb
cp output/pele.conf output/pele.conf.backup
cp output/adaptive.conf output/adaptive.conf.backup
python ../._addLigandConstraintsToPELEconf.py output 
python ../._changeAdaptiveIterations.py output --iterations 1 --steps 1
python -m pele_platform.main input_equilibration.yaml
cp output/pele.conf.backup output/pele.conf
cp output/adaptive.conf.backup output/adaptive.conf
python -m pele_platform.main input_restart.yaml
cd ../../

conda deactivate 

