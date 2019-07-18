#!/bin/bash

# 4 CPU
# 20 Go

# keep some info
TIMESTAMP=$(date +%Y-%m-%d_%Hh%Mm%Ss)
SCRIPT=$0
NAME=$(basename $0)
LOG_FOLDER="98_log_files"
echo "$SCRIPT"
cp "$SCRIPT" "$LOG_FOLDER"/"$TIMESTAMP"_"$NAME"

# Define options
GENOME="02_reference/genome.fasta"  # Genomic reference .fasta
TRIMMED_FOLDER="04_trimmed_reads"
ALIGNED_FOLDER="05_aligned_bam"
TEMP_FOLDER="99_tmp/"
NCPUS=4

# Modules
module load bwa samtools

# Align reads
for file in $(ls $TRIMMED_FOLDER/*.fastq.gz | perl -pe 's/_R[12].*//g' | sort -u) #| grep -v '.md5') 
do
    base=$(basename $file)

    # Align
    bwameth.py --threads "$NCPUS" \
        --reference "$GENOME" \
        "$TRIMMED_FOLDER"/"$base"_R1.fastq.gz \
        "$TRIMMED_FOLDER"/"$base"_R2.fastq.gz |
        samtools -Sb -q 10 - |
        samtools sort - > "$ALIGNED_FOLDER"/"$base".bam

    samtools index "$ALIGNED_FOLDER"/"$base".bam
done

# Cleanup temp folder
rm -r "$TEMP_FOLDER"/*
