#!/bin/bash
# 1 CPU
# 100 Go

# Global variables
MARKDUPS="/prg/picard-tools/1.119/MarkDuplicates.jar"
ALIGNEDFOLDER="05_aligned"
DEDUPFOLDER="06_deduplicated"
METRICSFOLDER="98_metrics"
NCPUS=20

# Copy script to log folder
TIMESTAMP=$(date +%Y-%m-%d_%Hh%Mm%Ss)
SCRIPT=$0
NAME=$(basename $0)
LOG_FOLDER="10_logfiles"
cp "$SCRIPT" "$LOG_FOLDER"/"$TIMESTAMP"_"$NAME"

# Load needed modules
module load java/jdk/1.8.0_102

## Remove duplicates from bam alignments
#ls -1 "$ALIGNEDFOLDER"/*.bam |
#while read file
#do
#    echo "Deduplicating sample $file"

#    java -jar "$MARKDUPS" \
#        INPUT="$file" \
#        OUTPUT="$DEDUPFOLDER"/$(basename "$file" .bam).dedup.bam \
#        METRICS_FILE="$METRICSFOLDER"/$(basename "$file" .bam).metrics.txt \
#        VALIDATION_STRINGENCY=SILENT \
#        REMOVE_DUPLICATES=true
#done



# Remove duplicates from bam alignments with Gnu Parallel
ls -1 "$ALIGNEDFOLDER"/*.bam |
parallel -j 5 \
    java -jar "$MARKDUPS" \
    INPUT={} \
    OUTPUT="$DEDUPFOLDER"/{/.}.dedup.bam \
    METRICS_FILE="$METRICSFOLDER"/{/.}.metrics.txt \
    VALIDATION_STRINGENCY=SILENT \
    REMOVE_DUPLICATES=true \; echo
