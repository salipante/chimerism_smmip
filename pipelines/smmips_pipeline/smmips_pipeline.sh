#!/bin/bash

#smmips_pipeline
#preprocesses reads, pear assembles paired reads, splits into MIPs calls variants and counts read distribution
#need a config.txt pointing to SALIPANTE_ROOT (see config.txt.default) in the current directory to run
#nohup /mnt/disk4/labs/salipante/code/pipelines/smmips_pipeline/smmips_pipeline.sh standard /mnt/disk4/labs/salipante/data/analysis/smmips /mnt/disk4/labs/salipante/data/sequencing_runs/150313_Heme_mip1 /mnt/disk4/labs/slaipante/code/pipelines/smmips/mips_regions.txt /mnt/disk4/labs/salipante/databases/hg37/hg37.fa COUNTONLY 10 

PFX=$1;
SAVEPATH=$2;
DATAPATH=$3;
SMMIPSPATH=$4;
REFERENCE_GENOME=$5;
PIPELINE=$6; #COPYNUM for copynum Anything(but something) for HEME
COUNTONLY=$7; #COUNTONLY doesn't call variants COUNTCONTINUE calls variants after running COUNTONLY anything else does it all
STRANDED=$8; #if $STRANDED == "STRANDED" then variants must appear on both strands
CORES=$9;

#config.txt must be in the $SAVEPATH directory so it can be found
if [ -e $SAVEPATH/config.txt ] #read in config.txt file to get top of code branch
then
   SALIPANTE_ROOT=$(cat config.txt);
   source $SALIPANTE_ROOT/code/source.sh  $SALIPANTE_ROOT;
else
   echo "No config.txt found in $SAVEPATH";
   exit;
fi

#make Analysis folder 
mkdir -p $SAVEPATH/$PFX.Analysis

if [ $COUNTONLY == "COUNTCONTINUE" ]
then
   mv $SAVEPATH/$PFX.Analysis/$PFX.log $SAVEPATH/$PFX.Analysis/$PFX.log.countonly
   mv $SAVEPATH/$PFX.Analysis/nohup.out $SAVEPATH/$PFX.Analysis/nohup.out.countonly
fi

echo "Running smips pipeline " > $SAVEPATH/$PFX.Analysis/$PFX.log;
date +"%D %H:%M" >> $SAVEPATH/$PFX.Analysis/$PFX.log;
echo "Command line:" >> $SAVEPATH/$PFX.Analysis/$PFX.log;
echo "$0 $1 $2 $3 $4 $5 $6 $7 $8 $9" >> $SAVEPATH/$PFX.Analysis/$PFX.log;

if [ $COUNTONLY != "COUNTCONTINUE" ]
then
   #1) Preprocess reads (deduplicate and trim)

   # for cellfree mips panel arm is 42, min capture is 8, still have bardcode which is 8 so smallest we want is 58
   # but we want to allow for indels to cut the number to 53 for copy number smmips the number is 100
   if [ $PIPELINE == "COPYNUM" ]
   then
      $PREPROCESS_READS_MISEQ/preprocess_reads_smmips.sh $SAVEPATH $PFX $SAVEPATH/$PFX.Analysis $DATAPATH $PREPROCESS_READS_MISEQ 140
      #2) assemble each pair of reads into a single longer read 
      $PEAR_SELF_ASSEMBLY/pear_self_assembly.sh $SAVEPATH $SAVEPATH/$PFX.Analysis/$PFX.R1.trimmed.fastq.gz $SAVEPATH/$PFX.Analysis/$PFX.R2.trimmed.fastq.gz $PFX $SAVEPATH/$PFX.Analysis 140 $CORES
   else
      $PREPROCESS_READS_MISEQ/preprocess_reads_smmips.sh $SAVEPATH $PFX $SAVEPATH/$PFX.Analysis $DATAPATH $PREPROCESS_READS_MISEQ 53
      #2) assemble each pair of reads into a single longer read
      $PEAR_SELF_ASSEMBLY/pear_self_assembly.sh $SAVEPATH $SAVEPATH/$PFX.Analysis/$PFX.R1.trimmed.fastq.gz $SAVEPATH/$PFX.Analysis/$PFX.R2.trimmed.fastq.gz $PFX $SAVEPATH/$PFX.Analysis 53 $CORES
  fi

   gunzip $SAVEPATH/$PFX.Analysis/$PFX.assembled.fastq.gz
   #3) rename out of SRA format, add molecular tag to name and trim the molecular tag from end of read
   perl $SALIPANTE_ROOT/code/pipelines/smmips_pipeline/rename_smips_reads.pl $SAVEPATH/$PFX.Analysis/$PFX.assembled.fastq
   #move properly named and trimmed reads to $SAVEPATH/$PFX.Analysis/$PFX.assembled.fastq
   mv $SAVEPATH/$PFX.Analysis/$PFX.assembled.fastq.tags $SAVEPATH/$PFX.Analysis/$PFX.assembled.fastq
fi

echo "Splitting fastqs into region-based fastqs " >> $SAVEPATH/$PFX.Analysis/$PFX.log;
date +"%D %H:%M" >> $SAVEPATH/$PFX.Analysis/$PFX.log;
#4) split reads by region(gene) by mapping to regions from mips design document
   $SPLIT_MIPS_READS/split_mips_reads.sh $SAVEPATH $PFX $SAVEPATH/$PFX.Analysis $CORES $REFERENCE_GENOME $SAVEPATH/$PFX.Analysis/$PFX.assembled.fastq $SMMIPSPATH $SPLIT_MIPS_READS $PIPELINE $COUNTONLY
echo "Finished splitting fastqs into region-based fastqs " >> $SAVEPATH/$PFX.Analysis/$PFX.log;
date +"%D %H:%M" >> $SAVEPATH/$PFX.Analysis/$PFX.log;

if [ $COUNTONLY != "COUNTONLY" ]
then

   if [ $STRANDED != "STRANDED" ]
   then   
   grep -h chr $SAVEPATH/$PFX.Analysis/*/*.vcf $SAVEPATH/$PFX.Analysis/*/*.vcfR | sort -k 1,1 -k 2,2n -k 4,4 -k 5,5 > $SAVEPATH/$PFX.Analysis/combine_all_vcfs_sorted.vcf
      perl $SPLIT_MIPS_READS/combine_final_vcfs.pl $SAVEPATH/$PFX.Analysis/combine_all_vcfs_sorted.vcf $SAVEPATH/$PFX.Analysis/combine_all_vcfs_condensed.vcf
      perl $SPLIT_MIPS_READS/split_vcf_indel.pl $SAVEPATH/$PFX.Analysis/combine_all_vcfs_condensed.vcf

      #ANNOVAR point mutations
      mkdir $SAVEPATH/$PFX.Analysis/ANNOVAR
      cp $SAVEPATH/$PFX.Analysis/combine_all_vcfs_condensed.vcf.point $SAVEPATH/$PFX.Analysis/ANNOVAR
      perl $ANNOVAR_ROOT/table_annovar.pl $SAVEPATH/$PFX.Analysis/ANNOVAR/combine_all_vcfs_condensed.vcf.point \
      --protocol refGene,segdup,snp138,exac03,dbscsnv11,1000g2015aug_all,1000g2015aug_amr,1000g2015aug_eur,1000g2015aug_eas,1000g2015aug_sas,1000g2015aug_afr,ljb26_all,esp6500siv2_all,esp6500siv2_aa,esp6500siv2_ea,cosmic70,clinvar_20150629,nci60 \
      --operation g,r,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f \
      --buildver hg19 \
      --otherinfo \
      --vcfinput \
      $ANNOVARLIB_PATH

      #ANNOVAR indel mutations
      mkdir $SAVEPATH/$PFX.Analysis/ANNOVAR_indel
      cp $SAVEPATH/$PFX.Analysis/combine_all_vcfs_condensed.vcf.indel $SAVEPATH/$PFX.Analysis/ANNOVAR_indel
      perl $ANNOVAR_ROOT/table_annovar.pl $SAVEPATH/$PFX.Analysis/ANNOVAR_indel/combine_all_vcfs_condensed.vcf.indel \
      --protocol refGene,segdup,snp138,exac03,dbscsnv11,1000g2015aug_all,1000g2015aug_amr,1000g2015aug_eur,1000g2015aug_eas,1000g2015aug_sas,1000g2015aug_afr,ljb26_all,esp6500siv2_all,esp6500siv2_aa,esp6500siv2_ea,cosmic70,clinvar_20150629,nci60 \
      --operation g,r,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f \
      --buildver hg19 \
      --otherinfo \
      --vcfinput \
      $ANNOVARLIB_PATH
   else
      grep -h chr $SAVEPATH/$PFX.Analysis/*/*.vcf | sort -k 1,1 -k 2,2n -k 4,4 -k 5,5 > $SAVEPATH/$PFX.Analysis/combine_all_vcfs_sorted.vcf
      perl $SPLIT_MIPS_READS/combine_final_vcfs.pl $SAVEPATH/$PFX.Analysis/combine_all_vcfs_sorted.vcf $SAVEPATH/$PFX.Analysis/combine_all_vcfs_condensed.vcf
      perl $SPLIT_MIPS_READS/split_vcf_indel.pl $SAVEPATH/$PFX.Analysis/combine_all_vcfs_condensed.vcf

      grep -h chr $SAVEPATH/$PFX.Analysis/*/*.vcfR | sort -k 1,1 -k 2,2n -k 4,4 -k 5,5 > $SAVEPATH/$PFX.Analysis/combine_all_vcfs_sorted.vcfR
      perl $SPLIT_MIPS_READS/combine_final_vcfs.pl $SAVEPATH/$PFX.Analysis/combine_all_vcfs_sorted.vcfR $SAVEPATH/$PFX.Analysis/combine_all_vcfs_condensed.vcfR
      perl $SPLIT_MIPS_READS/split_vcf_indel.pl $SAVEPATH/$PFX.Analysis/combine_all_vcfs_condensed.vcfR

      perl $SPLIT_MIPS_READS/smmips_both_strands.pl $SAVEPATH/$PFX.Analysis/combine_all_vcfs_condensed.vcf $SAVEPATH/$PFX.Analysis/combine_all_vcfs_condensed.vcfR $SAVEPATH/$PFX.Analysis/combine_all_vcfs_condensed_both_strands.vcf
      perl $SPLIT_MIPS_READS/split_vcf_indel.pl $SAVEPATH/$PFX.Analysis/combine_all_vcfs_condensed_both_strands.vcf

      #ANNOVAR both strands point mutations
      mkdir $SAVEPATH/$PFX.Analysis/ANNOVAR_both_strands
      cp $SAVEPATH/$PFX.Analysis/combine_all_vcfs_condensed_both_strands.vcf.point $SAVEPATH/$PFX.Analysis/ANNOVAR_both_strands
      perl $ANNOVAR_ROOT/table_annovar.pl $SAVEPATH/$PFX.Analysis/ANNOVAR_both_strands/combine_all_vcfs_condensed_both_strands.vcf.point \
      --protocol refGene,segdup,snp138,exac03,dbscsnv11,1000g2015aug_all,1000g2015aug_amr,1000g2015aug_eur,1000g2015aug_eas,1000g2015aug_sas,1000g2015aug_afr,ljb26_all,esp6500siv2_all,esp6500siv2_aa,esp6500siv2_ea,cosmic70,clinvar_20150629,nci60 \
      --operation g,r,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f \
      --buildver hg19 \
      --otherinfo \
      --vcfinput \
      $ANNOVARLIB_PATH

      #ANNOVAR both strands indel mutations
      mkdir $SAVEPATH/$PFX.Analysis/ANNOVAR_indel_both_strands
      cp $SAVEPATH/$PFX.Analysis/combine_all_vcfs_condensed_both_strands.vcf.indel $SAVEPATH/$PFX.Analysis/ANNOVAR_indel_both_strands
      perl $ANNOVAR_ROOT/table_annovar.pl $SAVEPATH/$PFX.Analysis/ANNOVAR_indel_both_strands/combine_all_vcfs_condensed_both_strands.vcf.indel \
      --protocol refGene,segdup,snp138,exac03,dbscsnv11,1000g2015aug_all,1000g2015aug_amr,1000g2015aug_eur,1000g2015aug_eas,1000g2015aug_sas,1000g2015aug_afr,ljb26_all,esp6500siv2_all,esp6500siv2_aa,esp6500siv2_ea,cosmic70,clinvar_20150629,nci60 \
      --operation g,r,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f \
      --buildver hg19 \
      --otherinfo \
      --vcfinput \
      $ANNOVARLIB_PATH
      
      rm -f $SAVEPATH/$PFX.Analysis/combine_all_vcfs_sorted.vcfR
   fi

   rm -f $SAVEPATH/$PFX.Analysis/combine_all_vcfs_sorted.vcf
   rm -f $SAVEPATH/$PFX.Analysis/$PFX.R1.trimmed.fastq.gz
   rm -f $SAVEPATH/$PFX.Analysis/$PFX.R2.trimmed.fastq.gz
   rm -f $SAVEPATH/$PFX.Analysis/*.intermediate
fi

echo "Done running smips pipeline " >> $SAVEPATH/$PFX.Analysis/$PFX.log;
date +"%D %H:%M" >> $SAVEPATH/$PFX.Analysis/$PFX.log;
