#!/bin/bash

# keep some info
TIMESTAMP=$(date +%Y-%m-%d_%Hh%Mm%Ss)
SCRIPT=$0
NAME=$(basename $0)
LOG_FOLDER="10_logfiles"
cp "$SCRIPT" "$LOG_FOLDER"/"$TIMESTAMP"_"$NAME"

# Define options
GENOME="02_reference/genome.fasta"  # Genomic reference .fasta
TRIMMED_FOLDER="04_trimmed_reads"
ALIGNED_FOLDER="05_aligned_bam"
TEMP_FOLDER="99_tmp/"
NCPUS=4
SAMPLE_FILE="$1"

# Modules
module load htslib/1.8

MethylDackel