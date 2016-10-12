#!/bin/bash -login
#PBS -l walltime=48:00:00,nodes=01:ppn=9,mem=20gb
#PBS -q main
#PBS -M adina.chuang@gmail.com
#PBS -m abe


module load Trimmomatic
#You need to figure out which version you want to run of Trimmomatic
#modify the qsub file
#First, put all your gzipped reads into a specific location and specify it below
#This requires that they are *gz and also have the standard R1/R2 unique naming schema
MY_PATH=/mnt/home/howead/metag-pipeline
TRIM_PATH=/opt/software/Trimmomatic/0.33
THREADS_TRIMMING=8
PAR_PATH=/mnt/home/howead/software/parallel-20120122/src

cd $MY_PATH
mkdir trimmed-reads
for x in *R1_001*gz;
do
echo "java -jar $TRIM_PATH/trimmomatic PE -phred33 -threads $THREADS_TRIMMING $x ${x%R1*}R2_001*fastq.gz trimmed-reads/${x%R1*}pe1 trimmed-reads/${x%R1*}se1 trimmed-reads/${x%R1*}pe2 trimmed-reads/${x%R1*}se2 ILLUMINACLIP:$TRIM_PATH/adapters/NexteraPE-PE.fa:2:30:10:8:TRUE LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36" >> trim.sh
done
cat trim.sh | $PAR_PATH/parallel

cd trimmed-reads
for x in *se1; do echo "cat $x ${x%se1*}se2 > ${x%se1}se12"; done >> cat_se.sh
cat cat_se.sh | $PAR_PATH/parallel


