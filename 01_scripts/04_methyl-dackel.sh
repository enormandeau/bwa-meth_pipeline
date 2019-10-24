#!/bin/bash

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
NCPUS=20

# Modules
module load htslib/1.8

# Gnu Parallel
ls -1 "$ALIGNED_FOLDER"/*.bam |
parallel -j "$NCPUS" \
    MethylDackel extract --maxVariantFrac 0.05 "$GENOME" {} \; \
    MethylDackel extract "$GENOME" {} \; \
    gzip {.}_CpG.bedGraph \; \
    MethylDackel extract --methylKit "$GENOME" {} \; \
    gzip {.}_CpG.methylKit \; \
    MethylDackel extract --mergeContext "$GENOME" {} \; \
    mv {.}_CpG.bedGraph {.}_CpG_merged.bedGraph \; \
    gzip {.}_CpG_merged.bedGraph \; \
    MethylDackel mbias "$GENOME" {} {.}_mbias
