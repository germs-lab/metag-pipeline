#!/bin/bash -login
#PBS -l walltime=150:00:00,nodes=01:ppn=8,mem=10gb
#PBS -q main
#PBS -M adina.chuang@gmail.com
#PBS -m abe
#PBS -A ged

#You need to figure out which version you want to run of Trimmomatic
#modify the qsub file
#First, put all your gzipped reads into a specific location and specify it below
#This requires that they are *gz and also have the standard R1/R2 unique naming schema
MY_PATH=/mnt/home/howead/metag-pipeline
ASSEMBLER_PATH=/mnt/home/howead/software/megahit
THREADS=8
MEM=10e9
TRIMMED_READS_PATH=/mnt/home/howead/metag-pipeline/trimmed-reads
PAR_PATH=/mnt/home/howead/software/parallel-20120122/src

cd $MY_PATH
echo "cat $TRIMMED_READS_PATH/*pe1 >> $TRIMMED_READS_PATH/pe1.fq" > pre-assembly-wrangle.sh
echo "cat $TRIMMED_READS_PATH/*pe2 >> $TRIMMED_READS_PATH/pe2.fq" >> pre-assembly-wrangle.sh
echo "cat $TRIMMED_READS_PATH/*se12 >> $TRIMMED_READS_PATH/se12.fq" >> pre-assembly-wrangle.sh
cat pre-assembly-wrangle.sh | $PAR_PATH/parallel
echo "$ASSEMBLER_PATH/megahit --kmin-1pass -1 $TRIMMED_READS_PATH/pe1.fq -2 $TRIMMED_READS_PATH/pe2.fq -r $TRIMMED_READS_PATH/se12.fq --presets meta-large -o assembly -m $MEM" > megahit.sh
bash megahit.sh


