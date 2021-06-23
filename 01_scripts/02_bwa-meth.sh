#!/bin/bash

# SAMPLE_FILE has one sample name per line, without the _R1.fastq.gz part

# First split sample list to align into different files with:
# cd 04_trimmed
# ls -1 *R1.fastq.gz | perl -pe 's/_R1\.fastq\.gz//' > ../all_samples_for_alignment.txt
# cd ..
# mkdir samples_split
# split -a 4 -l 100 -d all_samples_for_alignment.txt samples_split/samples_split.

## With GNU Parallel
# ls -1 samples_split/* | parallel -k -j 10 srun -c 4 --mem 10G -p large --time 21-00:00 -J bwaMeth -o 10_logfiles/bwaMeth_%j.log ./01_scripts/02_bwa-meth.sh {} &

## srun
# srun -c 4 --mem 10G -p large --time 21-00:00 -J bwaMeth -o 10_logfiles/bwaMeth_%j.log ./01_scripts/02_bwa-meth.sh <SAMPLE_FILE>

# keep some info
TIMESTAMP=$(date +%Y-%m-%d_%Hh%Mm%Ss)
SCRIPT=$0
NAME=$(basename $0)
LOG_FOLDER="10_logfiles"
cp "$SCRIPT" "$LOG_FOLDER"/"$TIMESTAMP"_"$NAME"

# Define options
GENOME="02_reference/genome.fasta"  # Genomic reference .fasta
TRIMMED_FOLDER="04_trimmed"
ALIGNED_FOLDER="05_aligned"
TEMP_FOLDER="99_tmp/"
NCPUS=4
SAMPLE_FILE="$1"

# Modules
module load bwa samtools

# Align reads
#for file in $(ls $TRIMMED_FOLDER/*.fastq.gz | perl -pe 's/_R[12].*//g' | sort -u) #| grep -v '.md5')
cat "$SAMPLE_FILE" |
while read file
do
    base=$(basename $file)
    echo "Aligning $base"

    # Align
    bwameth.py --threads "$NCPUS" \
        --reference "$GENOME" \
        "$TRIMMED_FOLDER"/"$base"_R1.fastq.gz \
        "$TRIMMED_FOLDER"/"$base"_R2.fastq.gz |
        samtools view -Sb -q 10 - |
        samtools sort - > "$ALIGNED_FOLDER"/"$base".bam

    samtools index "$ALIGNED_FOLDER"/"$base".bam
done

# Cleanup temp folder
rm -r "$TEMP_FOLDER"/* 2>/dev/null
