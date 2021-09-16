#!/bin/bash

#trims and de-duplicates PCR replicates of illumina fastq reads.
#trimmed reads are saved to savepath

#nohup /mnt/disk4/labs/salipante/code/functions/preprocess_reads_miseq/preprocess_reads_miseq.sh SAVEPATH A2A /mnt/disk4/labs/salipante/code/preproces_test /mnt/disk4/labs/salipante/test_data /mnt/disk4/labs/salipante/code/functions/preprocess_reads_miseq &

SAVEPATH_ROOT=$1;
PFX=$2;
SAVEPATH=$3;
DATAPATH=$4;
PREPROCESS_READS_MISEQ=$5;
MIN_LENGTH=$6;

SALIPANTE_ROOT=$(cat $SAVEPATH_ROOT/config.txt);
source $SALIPANTE_ROOT/code/source.sh $SALIPANTE_ROOT;

#force make of save path
mkdir -p $SAVEPATH;

#1) Deduce proper name of reads from MiSeq or NextSeq
echo 'Preprocess reads' >> $SAVEPATH/$PFX.log; 
date +"%D %H:%M" >> $SAVEPATH/$PFX.log; 

MISEQ=$(echo $DATAPATH/${PFX}_S*_L001_R1_001.fastq.gz)
NEXTSEQ=$(echo $DATAPATH/${PFX}_S*_R1_001.fastq.gz)
if [ -f $MISEQ ]; then #MiSeq format
   R1=$(echo $DATAPATH/${PFX}_S*_L001_R1_001.fastq.gz)
   R2=$(echo $DATAPATH/${PFX}_S*_L001_R2_001.fastq.gz)
elif [ -f $NEXTSEQ ]; then #NextSeq format
   R1=$(echo $DATAPATH/${PFX}_S*_R1_001.fastq.gz)
   R2=$(echo $DATAPATH/${PFX}_S*_R2_001.fastq.gz)
else
   echo "$DATAPATH/${PFX}_S*_L001_R1_001.fastq.gz nor $DATAPATH/${PFX}_S*_R1_001.fastq.gz exist";
fi
 
#2) Trim adaptors off and remove reads that are too short.  Do not duplicates.

# for cellfree mips panel arm is 42, min capture is 8, still have bardcode which is 8 so smallest we want is 58
# but we want to allow for indels to cut the number to 53
#$EA_UTILS_ROOT/fastq-mcf -o $SAVEPATH/$PFX.R1.trimmed.fastq -o $SAVEPATH/$PFX.R2.trimmed.fastq -l $MIN_LENGTH -k 0 -q 0 $PREPROCESS_READS_MISEQ/smmip_adaptors.fa $R1  $R2  1>> $SAVEPATH/$PFX.log;

SING_DATA="singularity exec --bind /mnt/disk4/labs/salipante/:/mnt/disk4/labs/salipante/:ro --bind $(pwd) --pwd $(pwd)"
$SING_DATA /mnt/disk4/labs/salipante/programs/sing_images/ea-utils-1.1.2.779.simg fastq-mcf -o $SAVEPATH/$PFX.R1.trimmed.fastq -o $SAVEPATH/$PFX.R2.trimmed.fastq -l $MIN_LENGTH -k 0 -q 0 $PREPROCESS_READS_MISEQ/smmip_adaptors.fa $R1  $R2  1>> $SAVEPATH/$PFX.log;


gzip $SAVEPATH/$PFX.R1.trimmed.fastq &
gzip $SAVEPATH/$PFX.R2.trimmed.fastq &
wait

#3) Calculate complexity statistics

echo "Sample_ID	Total_reads	Filtered_reads	Short_after_clip	Complexity	Final_reads" > $SAVEPATH/$PFX.library_metrics.txt;

#extract total reads
TOTAL_READS=$(grep "Total reads: " $SAVEPATH/$PFX.log | cut -d " " -f 3)
SHORT_READS=$(grep "Too short after clip: " $SAVEPATH/$PFX.log | cut -d " " -f 5)
FILTERED_READS=$(grep "Filtered on duplicates: " $SAVEPATH/$PFX.log | cut -d " " -f 4)

if [ -z $SHORT_READS ]; then  #if not set because grep above didn't work
  SHORT_READS=0; 
fi
if [ -z $FILTERED_READS ]; then  #if not set because grep above didn't work
  FILTERED_READS=0; 
fi

#calculate final reads
FINAL_READS=$(($TOTAL_READS - $FILTERED_READS - $SHORT_READS))

#calculate complexity with floating point 
UNIQUE_READS=$(( $TOTAL_READS - $FILTERED_READS ))
COMPLEXITY=$( echo $UNIQUE_READS / $TOTAL_READS | bc -l )


echo "$PFX	$TOTAL_READS	$FILTERED_READS	$SHORT_READS	$COMPLEXITY	$FINAL_READS" >> $SAVEPATH/$PFX.library_metrics.txt;

echo 'End Preprocess reads' >> $SAVEPATH/$PFX.log; 
date +"%D %H:%M" >> $SAVEPATH/$PFX.log; 
