#!/bin/bash -login
#PBS -l walltime=150:00:00,nodes=01:ppn=8,mem=10gb
#PBS -q main
#PBS -M adina.chuang@gmail.com
#PBS -m abe
#PBS -A ged

MY_PATH=/mnt/home/howead/metag-pipeline
MAPPER_PATH=/mnt/home/howead/software/bowtie2-2.2.9
SAMTOOLS_PATH=/mnt/home/howead/software/samtools-1.3.1
THREADS=8
PAR_PATH=/mnt/home/howead/software/parallel-20120122/src
CONTIGS_FILE=/mnt/home/howead/metag-pipeline/assembly/contigs.test.fa
CONTIGS_FILE_B=`basename $CONTIGS_FILE`

cd $MY_PATH
mkdir mapping-data
cd mapping-data
ln -s $CONTIGS_FILE .
$MAPPER_PATH/bowtie2-build $CONTIGS_FILE $CONTIGS_FILE_B
cd $MY_PATH
for x in *R1*gz; do echo $MAPPER_PATH/bowtie2 -x mapping-data/$CONTIGS_FILE_B -1 $x -2 ${x%*R1*}*R2*gz -S mapping-data/${x%*_R1*}.sam; done > map.sh
cat map.sh | $PAR_PATH/parallel
for x in mapping-data/*sam; do echo "$SAMTOOLS_PATH/samtools view -b -S $x -t mapping-data/$CONTIGS_FILE_B > $x.bam"; done > sam.sh
cat sam.sh | $PAR_PATH/parallel
for x in mapping-data/*bam; do echo "$SAMTOOLS_PATH/samtools sort $x -o $x.sorted"; done > samtools.sort.sh
cat samtools.sort.sh | $PAR_PATH/parallel
for x in mapping-data/*sorted; do echo "$SAMTOOLS_PATH/samtools index $x"; done > samtools-index.sh
cat samtools-index.sh | $PAR_PATH/parallel
