#!/bin/bash -login
#PBS -l walltime=150:00:00,nodes=1:ppn=32,mem=64gb
#PBS -q main
#PBS -M adina.chuang@gmail.com
#PBS -m abe
#PBS -A ged

MY_PATH=/mnt/home/howead/metag-pipeline-manure/assembly
THREADS=32
MEM=50e9
TRIMMED_READS_PATH=/mnt/home/howead/metag-pipeline/trimmed-reads
PAR_PATH=/mnt/home/howead/software/parallel-20120122/src
CONTIGS=/mnt/home/howead/metag-pipeline-manure/assembly/manure.final.contigs.fa

module load Biopython
cd /mnt/home/howead
source rgi/bin/activate

cd $MY_PATH
/mnt/home/howead/rgi/release-rgi-v3.1.1-58cad6a3b443abb290cf3df438fe558bc5bfec39/system-wide-installation/RGI-3.1.1/rgi -i $CONTIGS -o $CONTIGS-rgi -n $THREADS


