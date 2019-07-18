#!/bin/bash

# 4 CPU
# 10 Go

# Copy script as it was run
TIMESTAMP=$(date +%Y-%m-%d_%Hh%Mm%Ss)
SCRIPT=$0
NAME=$(basename $0)
LOG_FOLDER="98_log_files"
cp $SCRIPT $LOG_FOLDER/"$TIMESTAMP"_"$NAME"

# Global variables
LENGTH=100
QUAL=25
INPUT="03_raw_data"
OUTPUT="04_trimmed_reads"

# Trim reads with fastp
for file in $(ls "$INPUT"/*_R1.fastq.gz | perl -pe 's/R[12]\.fastq\.gz//g')
do
    name=$(basename $file)

    # Fastp
    fastp -i "$file"R1.fastq.gz -I "$file"R2.fastq.gz \
        -o $OUTPUT/"$name"trimmed_R1.fastq.gz \
        -O $OUTPUT/"$name"trimmed_R2.fastq.gz  \
        --length_required="$LENGTH" \
        --qualified_quality_phred="$QUAL" \
        --correction \
        --trim_tail1=1 \
        --trim_tail2=1 \
        --json $OUTPUT/"$name".json \
        --html $OUTPUT/"$name".html  \
        --report_title="$name"report.html

done 2>&1 | tee 98_log_files/"$TIMESTAMP"_fastp.log
