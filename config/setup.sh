#!/bin/sh
conda create -p ./conda-env -c conda-forge -c bioconda -y snakemake mamba python apptainer snakemake-executor-plugin-slurm pulp coin-or-cbc 
