#!/bin/sh

#script to create the required files and directories for a snakemake version 9.3.5 project


#config files
mkdir -p ./config

#the setup.sh script
echo "#!/bin/sh
conda create -p ./conda-env -c conda-forge -c bioconda -y snakemake mamba python apptainer snakemake-executor-plugin-slurm" > config/setup.sh

#the config.yaml file
echo "sample: one" > config/config.yaml


#the results directory
mkdir -p ./results


#the slurm directory
mkdir -p ./slurm

#slurm config.yaml
echo "executor: slurm
jobs: 10
use-conda: True

default-resources:
  mem_mb: 20000
  runtime: 120
  slurm_partition: "PARTITION"
  slurm_account: "PROJECT"
  ntasks: 1

# Additional settings to control SLURM log behavior
slurm-logdir: "slurm/logs/"
slurm-keep-successful-logs: True
" > slurm/config.yaml

#the workflow
mkdir -p workflow/envs
mkdir -p workflow/rules

#workflow/snakemake file
echo '###############################################################################
#About:
#
#
###############################################################################

configfile: "../config/config.yaml"

rule all:
    input: expand("../results/01_mapped_reads/A.sam")

rule bwa:
    input:
        "../example/genome.fasta",
	"../example/A.fastq"
    output:
        "../results/01_mapped_reads/A.sam"
    threads:
        4
    resources:
        mem_mb = 1024*100,
	runtime = 10
    shell:
        """
	    bwa mem -t {threads} {input[0]} {input{1}} > {output}
	"""
' > workflow/rules/01_snakemake.smk


#.gitignore
echo "conda-env > .gitignore"
echo ".snakemake >> .gitignore"
echo "./slurm/logs/* >> .gitignore"
