# Chimerism smMIPS pipeline README #

# This is the analytical pipeline used to analyze chimerism for this paper:
# "Ultrasensitive detection and quantitation of genomic chimerism by single-molecule molecular inversion probe capture and high throughput sequencing of copy number deletion polymorphisms"
# version 1.0

# create a code directory to clone into (must be named code)
# git clone https://github.com/salipante/chimerism_smmip into that code directory 
# install Dependencies into a common directory:
#    ea-utils.1.1.2-686
#    pear-0.9.4-bin-64.tar
#    bwa-0.7.12
#    samtools-1.1
#    VarScan.v2.3.7
#    pear-0.9.4-bin-64.tar
#    table_annovar.pl Version: $Date: 2015-06-17 21:43:53 -0700 (Wed, 17 Jun 2015)
#    annovar libraries: refGene,segdup,snp138,exac03,dbscsnv11,1000g2015aug_all,1000g2015aug_amr,1000g2015aug_eur,1000g2015aug_eas,
#                       1000g2015aug_sas,1000g2015aug_afr,ljb26_all,esp6500siv2_all,esp6500siv2_aa,esp6500siv2_ea,cosmic70,clinvar_20150629,nci60
#    hg37.fa reference genome
# 
# perl modules Switch and Math::CDF need to be installed
# The read files need to be named in this format ${PFX}_S*_L001_R1_001.fastq.gz where ${PFX} is the [readfile prefix]
# edit source.sh pointing environment variables to the proper places for the above files
#   set SALIPANTE_PROGRAMS_ROOT to where you installed the above dependencies
#   set PERL5LIB to where you have installed the switch and Math::CDF perl modules
#   set ANNOVARLIB_PATH= to where you have installed the ANNOVAR libraries
# create a config.txt in the directory you are going to run the pipeline from has the path to the directory you created the code subdirectory in
# that file simply contains the link to the top of the cloned repo
#
# also note that the pipeline assumes readnames in a format like this "@M00745:142:000000000-D2RPB:1:1101:18248:1845" (format coming from illumina sequencers)
# so if you are using our SRA reads since the rename the reads to look like this "@SRR5220259.1" you need to rename them to look like the above.  Text after the 
# name is not used and doesn't need to be changed. 

# command line:
# nohup [path to script]/smmips_pipeline.sh  [readfile prefix] [directory to write output also where config.txt exists] [path to directory with reads] [path to smmips file in the pipelines/smmips_pipeline/mips_regions.txt] [path to human genome] [version of pipeline COPYNEM] [in which mode to run COUNTONLY] [NOTSTRANDED] [# of cores to use]
# example:
#  nohup /home/local/code/pipelines/smmips_pipeline/msi_smmips_pipeline.sh  sample1 /home/local/smmips /home/local/sequencing_runs/  /home/local/code/pipelines/smmips_pipeline/cop_num.txt /homr/local/databases/hg37/hg37.fa COPYNUM COUNTONLY NOTSTRANDED 20

# for questions about this pipeline send email to waalkes@uw.edu
# for citing this code use the same reference as the paper above
