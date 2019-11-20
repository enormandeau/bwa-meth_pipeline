#!/bin/bash

# keep some info
TIMESTAMP=$(date +%Y-%m-%d_%Hh%Mm%Ss)
SCRIPT=$0
NAME=$(basename $0)
LOG_FOLDER="10_logfiles"
cp "$SCRIPT" "$LOG_FOLDER"/"$TIMESTAMP"_"$NAME"

# Define options
GENOME="02_reference/genome.fasta"  # Genomic reference .fasta
DEDUPLICATED_FOLDER="06_deduplicated"
METHYLDACKEL_FOLDER="07_methyl_dackel"
TEMP_FOLDER="99_tmp/"
NCPUS=8

# Modules
module load htslib/1.8

# Gnu Parallel
ls -1 "$DEDUPLICATED_FOLDER"/*.bam |
parallel -j "$NCPUS" \
    MethylDackel mbias "$GENOME" {} {.}_mbias

# Move files to METHYLDACKEL_FOLDER
ls -1 "$DEDUPLICATED_FOLDER"/ | grep -v \.bam | parallel -j "$NCPUS" mv "$DEDUPLICATED_FOLDER"/{} "$METHYLDACKEL_FOLDER"
