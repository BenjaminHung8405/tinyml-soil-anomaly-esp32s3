#!/bin/bash
#SBATCH --job-name=fit_combos
#SBATCH --ntasks=1
#SBATCH --mem=4gb
#SBATCH --partition=short
#SBATCH --time=1-00:00:00

cd /home/quentin.read/GitHub/twi-moisture
module load r/4.1.2
Rscript2 fit_combos.R

