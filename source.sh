#!/bin/bash

#to use, enter "source $SALIPANTE_ROOT/source.sh $SALIPANTE_ROOT" in each script.

# Define environment variables providing paths to reference data, programs, etc

# Export all defined variables
set -a 

#directory where salipante_root is
SALIPANTE_ROOT=$1;
SALIPANTE_PROGRAMS_ROOT="/mnt/disk4/labs/salipante/programs";
SALIPANTE_DB_ROOT="/mnt/disk4/labs/salipante/databases";

#Databases
PATH_TO_REFS="$SALIPANTE_DB_ROOT/reference_genomes";
#download_and_format_genome.sh
#snpeff_genbank_to_database.sh
#snpeff_identify_and_get_reference.sh
#summarize_abyss_and_strain_id.sh

#export PERL5LIB to find our perl modules
export PERL5LIB=/mnt/disk4/labs/salipante/programs/lib/perl/5.26.1/lib/perl5
#/mnt/disk4/labs/salipante/programs/lib/perl/site_perl/5.18.2:\
#/mnt/disk4/labs/salipante/programs/lib/perl/site_perl:\
#/mnt/disk4/labs/salipante/programs/share/perl/5.18.2

SNPEFF_DATA="$SALIPANTE_DB_ROOT/snpeff/data";
# NOTE hardcoded path in the programs directory needs to be changed if moving SALIPANTE_ROOT here is where it is:
# snpEff/snpEff.config:data.dir =  /mnt/disk4/labs/salipante/databases/snpeff/data
#used by:
#snpeff_identify_and_get_reference.sh
#snpeff_genbank_to_database.sh
#snpeff_pangenome_to_database/multifasta_to_genbank.pl
#snpeff_pangenome_to_database/snpeff_pangenome_to_database.sh

BLAST_NT="$SALIPANTE_DB_ROOT/BLAST_db/NT/nt";
KRAKEN_DB="$SALIPANTE_DB_ROOT/kraken/ncbi_bacterial_2015-04-10";

#location of small multipurpose utility fuctions
UTILITIES="$SALIPANTE_ROOT/code/functions/utilities"
#used by
#strip_vcf_header.pl de_novo_assemble_non_mapping_reads.sh
#strip_vcf_header.pl align_and_variant_calling_multiple_copy_gene.sh

#bash functions
PREPROCESS_READS_MISEQ="$SALIPANTE_ROOT/code/functions/preprocess_reads_miseq"
#used by
#align_and_variant_calling.sh
#de_novo_assembly_and_strain_id.sh
#de_novo_assemble_non_mapping_reads.sh
#de_novo_assemble_non_mapping_reads/align_and_variant_calling_with_ranges.sh
#de_novo_assemble_non_mapping_reads/de_novo_assembly_and_strain_id_paired_and_single.sh
#smmips_pipeline/smmips_pipeline.sh
#msi_smmips_pipeline/msi_smmips_pipeline.sh
#PROKKA_variant_call.sh

ABYSS_ASSEMBLE="$SALIPANTE_ROOT/code/functions/abyss_assemble"
#used by
#de_novo_assembly_and_strain_id.sh
#de_novo_assemble_non_mapping_reads/de_novo_assembly_and_strain_id_paired_and_single.sh
#PROKKA_variant_call.sh

BLAST_AGAINST_DATABASE="$SALIPANTE_ROOT/code/functions/blast_against_database"
#used by
#de_novo_assembly_and_strain_id.sh
#de_novo_assemble_non_mapping_reads/de_novo_assembly_and_strain_id_paired_and_single.sh

DOWNLOAD_AND_FORMAT_GENOME="$SALIPANTE_ROOT/code/functions/download_and_format_genome"
#used by
#de_novo_assembly_and_strain_id.sh
#de_novo_assemble_non_mapping_reads/de_novo_assemble_non_mapping_reads.sh
#de_novo_assemble_non_mapping_reads/de_novo_assembly_and_strain_id_paired_and_single.sh
#prepare_artificial_genome/prepare_artificial_genome.sh

SUMMARIZE_ABYSS_AND_STRAIN_ID="$SALIPANTE_ROOT/code/functions/summarize_abyss_and_strain_id"
#used by
#de_novo_assembly_and_strain_id.sh
#de_novo_assemble_non_mapping_reads/de_novo_assembly_and_strain_id_paired_and_single.sh
#de_novo_assemble_non_mapping_reads/summarize_abyss_and_strain_id.sh

PINDEL_RUN="$SALIPANTE_ROOT/code/functions/pindel_run"
SNPEFF_ANNOTATE="$SALIPANTE_ROOT/code/functions/snpeff_annotate"
#used by
#align_and_variant_calling.sh
#de_novo_assemble_non_mapping_reads/align_and_variant_calling_with_ranges.sh
#de_novo_assemble_non_mapping_reads/de_novo_assemble_non_mapping_reads.sh

SNPEFF_GENBANK_TO_DATABASE="$SALIPANTE_ROOT/code/functions/snpeff_genbank_to_database"
#used by
#de_novo_assembly_and_strain_id.sh
#de_novo_assemble_non_mapping_reads/de_novo_assemble_non_mapping_reads.sh
#de_novo_assemble_non_mapping_reads/de_novo_assembly_and_strain_id_paired_and_single.sh

SNPEFF_EXTRACT_CHROMOSOME_NAME="$SALIPANTE_ROOT/code/functions/snpeff_extract_chromosome_name"
#used by
#align_and_variant_calling.sh
#de_novo_assemble_non_mapping_reads/align_and_variant_calling_with_ranges.sh
#de_novo_assemble_non_mapping_reads/de_novo_assemble_non_mapping_reads.sh

BWA_ALIGN="$SALIPANTE_ROOT/code/functions/bwa_align"
#used by
#align_and_variant_calling.sh
#de_novo_assemble_non_mapping_reads/bwa_align_paired_and_single.sh
#de_novo_assemble_non_mapping_reads/de_novo_assemble_non_mapping_reads.sh

SAMTOOLS_VARIANT_CALLING="$SALIPANTE_ROOT/code/functions/samtools_variant_calling"
#used by
#align_and_variant_calling.sh
#de_novo_assemble_non_mapping_reads.sh
#de_novo_assemble_non_mapping_reads/de_novo_assemble_non_mapping_reads.sh

VARSCAN_VARIANT_CALLING="$SALIPANTE_ROOT/code/functions/varscan_variant_calling"
#used by
#align_and_variant_calling_varscan.sh


KRAKEN_CLASSIFY="$SALIPANTE_ROOT/code/functions/kraken_classify"
#NOTE: need to install kraken on any new share.  At install it takes a hardcoded path to its directory
#used by
#de_novo_assembly_and_strain_id.sh

MERGE_VCF_DIRECTORY="$SALIPANTE_ROOT/code/functions/merge_vcf_directory"
#used by
#epidemiology_analysis_samtools.sh

EXTRACT_UNUSED_READS="$SALIPANTE_ROOT/code/functions/extract_unused_reads"
#used by
#align_and_variant_calling.sh
#de_novo_assemble_non_mapping_reads.sh
#de_novo_assemble_non_mapping_reads/de_novo_assemble_non_mapping_reads.sh

PEAR_SELF_ASSEMBLY="$SALIPANTE_ROOT/code/functions/pear_self_assembly"
#used by
#smmips_pipeline.sh
#msi_smmips_pipeline.sh

SPLIT_MIPS_READS="$SALIPANTE_ROOT/code/functions/split_mips_reads"
#used by
#smmips_pipeline.sh

MSI_SPLIT_MIPS_READS="$SALIPANTE_ROOT/code/functions/msi_split_mips_reads"
#used by
#msi_smmips_pipeline.sh


SNPEFF_IDENTIFY_AND_GET_REFERENCE="$SALIPANTE_ROOT/code/functions/snpeff_identify_and_get_reference"
#used by

PICARD_DEDUPE="$SALIPANTE_ROOT/code/functions/picard_dedupe"
#used by
#align_and_variant_calling.sh
#de_novo_assemble_non_mapping_reads.sh

SUPER_DEDUPER="$SALIPANTE_ROOT/code/functions/super-deduper"
#used by
#PROKKA_variant_call.sh

ORFEOME_GENERATION_DNA="$SALIPANTE_ROOT/code/functions/orfeome_generation_dna"
#used by

ORFEOME_MATRIX_DNA="$SALIPANTE_ROOT/code/functions/orfeome_matrix_dna"
#used by

PROKKA_ANNOTATE="$SALIPANTE_ROOT/code/functions/prokka_annotate/" 
#used by
#PROKKA_variant_call.sh

EPIDEMIOLOGY_ANALYSIS_SAMTOOLS="$SALIPANTE_ROOT/code/pipelines/epidemiology_analysis_samtools"
#used by
#PROKKA_variant_call.sh

GENE_READ_DEPTH="$SALIPANTE_ROOT/code/functions/gene_read_depth"
#used by

PLASMIDSEEKER="$SALIPANTE_ROOT/code/functions/plasmidseeker"
#used by align_variant_calling

############################################################
#perl functions
IDENTIFY_GENOME="$SALIPANTE_ROOT/code/functions/identify_genome"
#used by
#de_novo_assembly_and_strain_id.sh
#de_novo_assemble_non_mapping_reads/de_novo_assembly_and_strain_id_paired_and_single.sh

PINDEL_FILTER_AND_SNPEFF_PREP="$SALIPANTE_ROOT/code/functions/pindel_filter_and_snpeff_prep"
#used by
#align_and_variant_calling.sh
#de_novo_assemble_non_mapping_reads.sh
#de_novo_assemble_non_mapping_reads/align_and_variant_calling_with_ranges.sh

SAMTOOLS_FILTER_AND_SNPEFF_PREP="$SALIPANTE_ROOT/code/functions/samtools_filter_and_snpeff_prep"
#used by
#align_and_variant_calling.sh
#de_novo_assemble_non_mapping_reads.sh
#de_novo_assemble_non_mapping_reads/align_and_variant_calling_with_ranges.sh

SNPEFF_PREP="$SALIPANTE_ROOT/code/functions/snpeff_prep"
#used by
#align_and_variant_calling_varscan.sh

GENOMIC_COVERAGE_INTERVALS="$SALIPANTE_ROOT/code/functions/genomic_coverage_intervals"
#used by:
#samtools_variant_calling.sh which is used by bwa_samtools_and_snpeff.sh
#de_novo_assemble_non_mapping_reads.sh
#de_novo_assemble_non_mapping_reads/align_and_variant_calling_with_ranges.sh
#de_novo_assemble_non_mapping_reads/samtools_variant_calling_with_ranges.sh

VCF_FILL_IN_AMBIGUITY_MULTITHREAD_SAMTOOLS="$SALIPANTE_ROOT/code/functions/vcf_fill_in_ambiguity_multithread_samtools"
#used by:
#epidemiology_analysis_samtools.sh

VCF_TO_DISTANCEGRID_SHORTREAD_WHOLEGENOME="$SALIPANTE_ROOT/code/functions/vcf_to_distancegrid_shortread_wholegenome"
#used by:
#epidemiology_analysis_samtools.sh

VCF_TO_NEXUS_SHORTREAD_WHOLEGENOME="$SALIPANTE_ROOT/code/functions/vcf_to_nexus_shortread_wholegenome"
#used by:
#epidemiology_analysis_samtools.sh

REMOVE_UNREAL_VARIANTS="$SALIPANTE_ROOT/code/functions/remove_unreal_variants"
#used by:
#epidemiology_analysis_samtools.sh

GET_PLASMID_ID_NUMBERS="$SALIPANTE_ROOT/code/functions/get_plasmid_id_numbers"
#used by:
#de_novo_assemble_non_mapping_reads.sh

VCF_ANNOTATE_WITH_PROTEIN_FUNCTION="$SALIPANTE_ROOT/code/functions/vcf_annotate_with_protein_function"
#used by:
#de_novo_assemble_non_mapping_reads.sh

GENE_PRESENCE="$SALIPANTE_ROOT/code/functions/gene_presence"
#used by:
#align_and_variant_calling.sh
#de_novo_assemble_non_mapping_reads.sh

SNPEFF_PANGENOME_TO_DATABASE="$SALIPANTE_ROOT/code/functions/snpeff_pangenome_to_database";
#used by:
#

SNPEFF_ANNOTATE_PANGENOME="$SALIPANTE_ROOT/code/functions/snpeff_annotate_pangenome"
#used by:
#

VARSCAN_VARIANT_CALLING_ASSEMBLY="$SALIPANTE_ROOT/code/functions/varscan_variant_calling_assembly"
#used by:
#align_and_variant_calling_assembly.sh

PREPARE_ARTIFICIAL_GENOME="$SALIPANTE_ROOT/code/pipelines/prepare_artificial_genome"
#NOTE: this in pipelines, not functions
#used by:
#pipelines/prepare_artificial_genome/prepare_artificial_genome.sh

VCF_MERGED_DIFF="$SALIPANTE_ROOT/code/functions/vcf_merged_diff"
#used by
#PROKKA_variant_call.sh

PROKKA_ANNOTATE_VCF="$SALIPANTE_ROOT/code/functions/prokka_annotate_vcf"
#used by
#PROKKA_variant_call.sh


#Program files called by functions###########################
ABYSS_ROOT="$SALIPANTE_PROGRAMS_ROOT/abyss-2.0.2_install/bin";
#used by:
#abyss_assemble.sh

EA_UTILS_ROOT="$SALIPANTE_PROGRAMS_ROOT/ea-utils.1.1.2-686"; #
#used by:
#preprocess_reads.sh
#preprocess_reads_smmips.sh

BWA_ROOT="$SALIPANTE_PROGRAMS_ROOT/bwa-0.7.12";
#used by:
#download_and_format_genome.sh
#bwa_align.sh
#split_mips_reads/call_consensus.sh

#BLAST_ROOT="$SALIPANTE_PROGRAMS_ROOT/ncbi-blast-2.2.28+/bin";
BLAST_ROOT="$SALIPANTE_PROGRAMS_ROOT/ncbi-blast-2.10.0+/bin";
#used by:
#blast_against_database.sh
#prokka_annotate
#orfeome_matrix_dna.sh
#summarize_abyss_and_strain_id/pairwise_ani.sh

NUCMER="$SALIPANTE_PROGRAMS_ROOT/MUMmer3.23/nucmer";
#NOTE: need to install MUMmers3 on any new share.  Hardcoded paths from install
#used by:
#summarize_abyss_and_strain_id.sh

BCFTOOLS_ROOT="$SALIPANTE_PROGRAMS_ROOT/bcftools-1.1";
#samtools_variant_calling.sh

BCFTOOLS_ROOT_1_7="$SALIPANTE_PROGRAMS_ROOT/bcftools-1.7/bin";
#samtools_variant_calling.sh


HTSLIB_ROOT="$SALIPANTE_PROGRAMS_ROOT/htslib-1.1";
#used by:
#extract_unused_reads.sh
#merge_vcf_directory.sh

SAMTOOLS_ROOT="$SALIPANTE_PROGRAMS_ROOT/samtools-1.1/bin";
#used by:
#samtools_variant_calling.sh
#download_and_format_genome.sh
#extract_unused_reads.sh
#merge_vcf_directory.sh
#split_mips_reads/call_consensus.sh
#split_mips_reads/sam_to_fastq.pl
#split_mips_reads/split_mips_reads.sh

SUPER_DEDUPER_ROOT="$SALIPANTE_PROGRAMS_ROOT/Super-Deduper-master";
#used by:
#super-deduper.sh

PARALLEL_ROOT="$SALIPANTE_PROGRAMS_ROOT/parallel-20190122";
#used by:
#abyss_assemble.sh
#call_consensus.sh

SNPEFF_DIR="$SALIPANTE_PROGRAMS_ROOT/snpEff";
#used by:
#snpeff_annotate.sh which is used by align_and_variant_calling.sh
#snpeff_identify_and_get_reference.sh
#snpeff_extract_chromosome_name.sh
#snpeff_genbank_to_database.sh
#snpeff_pangenome_to_database/multifasta_to_genbank.pl
#snpeff_pangenome_to_database/snpeff_pangenome_to_database.sh
#snpeff_annotate_pangenome.sh which is used by align_and_variant_calling.sh

PICARD_ROOT="$SALIPANTE_PROGRAMS_ROOT/picard-tools-1.98";
#used by:
#pindel_run.sh

PICARD_SAM_FASTQ="$SALIPANTE_PROGRAMS_ROOT/picard-2.18.16/SamToFastq.jar";
#used by:
#extract_unused_reads.sh

PINDEL_ROOT="$SALIPANTE_PROGRAMS_ROOT/pindel";
#used by:
#pindel_run.sh

KRAKEN_ROOT="$SALIPANTE_PROGRAMS_ROOT/kraken-0.10.5-beta"
#used by:
#kraken_make_db.sh
#kraken_classify.sh

JELLYFISH_ROOT="$SALIPANTE_PROGRAMS_ROOT/jellyfish/bin"
#used by:
#kraken_make_db.sh

VCF_ROOT="$SALIPANTE_PROGRAMS_ROOT/vcftools_0.1.12b";
#used by:
#merge_vcf_directory.sh

PEAR="$SALIPANTE_PROGRAMS_ROOT/pear/bin/pear"
#used by:
#pear_self_assemble.sh

PROKKA_ROOT="$SALIPANTE_PROGRAMS_ROOT/prokka-1.12/bin"
#used by:
#prokka_annotate

HHMER_ROOT="$SALIPANTE_PROGRAMS_ROOT/hmmer-3.1b1/src"
#used by:
#prokka_annotate

PRODIGAL_ROOT="$SALIPANTE_PROGRAMS_ROOT/Prodigal-85fb746effc4ff6b58702233ad796c94cde22b1b"
#used by:
#prokka_annotate

TBL2ASN_ROOT="$SALIPANTE_PROGRAMS_ROOT"
#used by:
#prokka_annotate

INFERNAL_ROOT="$SALIPANTE_PROGRAMS_ROOT/infernal-1.1rc4/src"
#used by:
#prokka_annotate

BARRNAP_ROOT="$SALIPANTE_PROGRAMS_ROOT/barrnap-0.5/bin"
#used by:
#prokka_annotate

ARAGORN_ROOT="$SALIPANTE_PROGRAMS_ROOT/aragorn1.2.36"
#used by:
#prokka_annotate

CDHIT_ROOT="$SALIPANTE_PROGRAMS_ROOT/cd-hit-v4.6.1-2012-08-27"
#used by:
#orfeome_generation_dna.sh

VARSCAN="$SALIPANTE_PROGRAMS_ROOT/VarScan.v2.3.7/VarScan.v2.3.7.jar"
#used by:
#varscan_variant_calling_assembly/varscan_variant_calling_assembly.sh
#pipelines/align_and_variant_calling_multiple_copy_gene/align_and_variant_calling_multiple_copy_gene.sh
#pipelines/TCGA_MSI_calling

FGBIO="$SALIPANTE_PROGRAMS_ROOT/fgbio/fgbio-0.4.0.jar"
#used by:
#split_mips_reads

PICARD="$SALIPANTE_PROGRAMS_ROOT/picard-tools-2.17.2/picard-2.17.2.jar"
#used by:
#split_mips_reads

###########################################################
#third party tools called directly from pipelines
FASTTREE="$SALIPANTE_PROGRAMS_ROOT/FastTree"
#used by:
#epidemiology_analysis_samtools.sh

GENBANK_TO_FASTA="$SALIPANTE_ROOT/salipante_lab/code/functions/genbank_to_fasta"
#used by:
#

ANNOVAR_ROOT="$SALIPANTE_PROGRAMS_ROOT/annovar";
ANNOVARLIB_PATH="/mnt/disk2/com/Genomes/Annovar_files";
#used by:
#smmips_pipeline.sh
#msi_smmips_pipeline.sh

PLASMIDSEEKER_ROOT="$SALIPANTE_PROGRAMS_ROOT/PlasmidSeeker";
#used by plasmidseeker.sh

FQ_ROOT="$SALIPANTE_PROGRAMS_ROOT/fq";
#used by superdeduper.sh
