#!/bin/bash

#to use, enter "source $SALIPANTE_ROOT/source.sh $SALIPANTE_ROOT" in each script.

# Define environment variables providing paths to reference data, programs, etc

# Export all defined variables
set -a 

#directory where salipante_root is
SALIPANTE_ROOT=$1; #top of git cloned code, passed in from config.txt file
SALIPANTE_PROGRAMS_ROOT="/"; #path to installed dependencies

#export PERL5LIB to find our perl modules
export PERL5LIB=

#bash functions
PREPROCESS_READS_MISEQ="$SALIPANTE_ROOT/code/functions/preprocess_reads_miseq"
#used by
#smmips_pipeline/smmips_pipeline.sh

PEAR_SELF_ASSEMBLY="$SALIPANTE_ROOT/code/functions/pear_self_assembly"
#used by
#smmips_pipeline.sh

MSI_SPLIT_MIPS_READS="$SALIPANTE_ROOT/code/functions/msi_split_mips_reads"
#used by
#smmips_pipeline.sh

#Program files called by functions###########################

EA_UTILS_ROOT="$SALIPANTE_PROGRAMS_ROOT/ea-utils.1.1.2-686"; #
#used by:
#preprocess_reads_smmips.sh

BWA_ROOT="$SALIPANTE_PROGRAMS_ROOT/bwa-0.7.12";
#used by:
#split_mips_reads/call_consensus.sh

SAMTOOLS_ROOT="$SALIPANTE_PROGRAMS_ROOT/samtools-0.1.19";
#used by:
#split_mips_reads/call_consensus.sh
#split_mips_reads/sam_to_fastq.pl
#split_mips_reads/split_mips_reads.sh

SAMTOOLS_ROOT_1_1="$SALIPANTE_PROGRAMS_ROOT/samtools-1.1/bin";
#used by:
#split_mips_reads/call_consensus.sh
#split_mips_reads/split_mips_reads.sh

PARALLEL_ROOT="$SALIPANTE_PROGRAMS_ROOT/parallel-20141122";
#used by:
#call_consensus.sh

PEAR="$SALIPANTE_PROGRAMS_ROOT/pear/bin/pear"
#used by:
#pear_self_assemble.sh

VARSCAN="$SALIPANTE_PROGRAMS_ROOT/VarScan.v2.3.7/VarScan.v2.3.7.jar"
#used by:
#split_mips_reads/call_consensus.sh

###########################################################
#third party tools called directly from pipelines
ANNOVAR_ROOT="$SALIPANTE_PROGRAMS_ROOT/annovar";
ANNOVARLIB_PATH="/"; #path to location of annovar libraries
#used by:
#smmips_pipeline.sh
