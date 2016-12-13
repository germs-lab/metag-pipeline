#!/bin/bash -login
#PBS -l walltime=150:00:00,nodes=1:ppn=32,mem=100gb
#PBS -q main
#PBS -M adina.chuang@gmail.com
#PBS -m abe
#PBS -A ged

MY_PATH=/mnt/home/howead/metags-darte-round2-env
THREADS=32
MEM=100e9
TRIMMED_READS_PATH=/mnt/home/howead/metags-darte-round2-env/trimmed-reads
PAR_PATH=/mnt/home/howead/software/parallel-20120122/src
DB_PATH=/mnt/home/howead/arg-db/arg-cluster/all-arg-combined-cdhit-97
BLAST_PATH=/mnt/home/howead/software/ncbi-blast-2.4.0+/bin/blastn

module load screed

cd $MY_PATH
for x in $TRIMMED_READS_PATH/*pe1 $TRIMMED_READS_PATH/*pe2 $TRIMMED_READS_PATH/*se12; do echo "python fastq-to-fasta.py $x > $x.fa"; done >> make-fastas.sh
cat make-fastas.sh | $PAR_PATH/parallel
for x in $TRIMMED_READS_PATH/*fa; do echo $BLAST_PATH -db $DB_PATH -query $x -out $x.blastnout -evalue 1e-5 -outfmt 6; done >> blast.sh
cat blast.sh | $PAR_PATH/parallel



