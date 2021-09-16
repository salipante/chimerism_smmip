#!/bin/bash
# split mips reads into region then call consensus reads and find variants creates a final vcf for each region, position, molecular tag

#usage:
# $SPLIT_MIPS_READS/split_mips_reads.sh $PFX $SAVEPATH $CORES $REFERENCE_GENOME $DATAPATH/$PFX.R1.trimmed.fastq.gz $RANGE_FILE $SPLIT_MIPS_READS

#below are the variables that need to be defined:
SAVEPATH_ROOT=$1;
PFX=$2;
SAVEPATH=$3;
CORES=$4;
REFERENCE_GENOME=$5;
R1=$6;
RANGES_FILE=$7;
SPLIT_MIPS_READS=$8;
PIPELINE=$9
COUNTONLY=${10};

SALIPANTE_ROOT=$(cat $SAVEPATH_ROOT/config.txt);
source $SALIPANTE_ROOT/code/source.sh $SALIPANTE_ROOT;

echo -e "mip\t1\t2\t3\t4\t5\t6\t7\t8\t9\t10\t11\t12\t13\t14\t15\t16\t17\t18\t19\t20\t21\t22\t23\t24\t25\t26\t27\t28\t29\t30\t31\t32\t33\t34\t35\t36\t37\t38\t39\t40\t41\t42\t43\t44\t45\t46\t47\t48\t49\t50\ttotal\tweighted\tovercount" > $SAVEPATH/${PFX}_mip_counts.txt;

if [ $COUNTONLY != "COUNTCONTINUE" ]
then
  #1) BWA alignment
   echo "Start BWA alignment with bwa mem using $BWA_ROOT " >> $SAVEPATH/$PFX.log;
   date +"%D %H:%M" >> $SAVEPATH/$PFX.log;

   if [ $PIPELINE = "COPYNUM" ]
   then
#      SING_DATA="singularity exec --bind /mnt/disk4/labs/salipante/:/mnt/disk4/labs/salipante/:rw --bind $(pwd) --pwd $(pwd) "
#      $SING_DATA /mnt/disk4/labs/salipante/programs/sing_images/bwa-0.7.12.img mem -t $CORES $REFERENCE_GENOME $R1 | awk '$6 ~ /1[0-9][0-9]M/ || $1 ~ /@/ {print}' > $SAVEPATH/$PFX.sam 2>> $SAVEPATH/$PFX.log;
      $BWA_ROOT/bwa mem -t $CORES $REFERENCE_GENOME $R1 | awk '$6 ~ /1[0-9][0-9]M/ || $1 ~ /@/ {print}' > $SAVEPATH/$PFX.sam 2>> $SAVEPATH/$PFX.log;
      MATCH_QUAL=50;
   else
#      $SING_DATA /mnt/disk4/labs/salipante/programs/sing_images/bwa-0.7.12.img mem -t $CORES $REFERENCE_GENOME $R1 > $SAVEPATH/$PFX.sam 2>> $SAVEPATH/$PFX.log;
      $BWA_ROOT/bwa mem -t $CORES $REFERENCE_GENOME $R1 > $SAVEPATH/$PFX.sam 2>> $SAVEPATH/$PFX.log;
      MATCH_QUAL=1;
   fi

   echo 'Finished BWA alignment using bwa mem' >> $SAVEPATH/$PFX.log;
   date +"%D %H:%M" >> $SAVEPATH/$PFX.log;

   #2) create sam files for forward and reverse reads
#   $SING_DATA /mnt/disk4/labs/salipante/programs/sing_images/samtools-1.2.simg samtools view -q $MATCH_QUAL -f 16 -F 2048 -S $SAVEPATH/$PFX.sam -o $SAVEPATH/${PFX}F.sam 2>> $SAVEPATH/$PFX.log;
   $SAMTOOLS_ROOT/samtools view -q $MATCH_QUAL -f 16 -F 2048 -S $SAVEPATH/$PFX.sam -o $SAVEPATH/${PFX}F.sam 2>> $SAVEPATH/$PFX.log;
#   $SING_DATA /mnt/disk4/labs/salipante/programs/sing_images/samtools-1.2.simg samtools view -q $MATCH_QUAL -F 2064 -S $SAVEPATH/$PFX.sam -o $SAVEPATH/${PFX}R.sam 2>> $SAVEPATH/$PFX.log;
   $SAMTOOLS_ROOT/samtools view -q $MATCH_QUAL -F 2064 -S $SAVEPATH/$PFX.sam -o $SAVEPATH/${PFX}R.sam 2>> $SAVEPATH/$PFX.log;

   echo 'Starting chromosome grep' >> $SAVEPATH/$PFX.log;
   date +"%D %H:%M" >> $SAVEPATH/$PFX.log;

   #3) grep for chromosome specific reads
   LC_ALL=C fgrep "chr1	" $SAVEPATH/${PFX}F.sam | sort -k 4,4n > $SAVEPATH/chr1F.sam
   LC_ALL=C fgrep "chr2	" $SAVEPATH/${PFX}F.sam | sort -k 4,4n > $SAVEPATH/chr2F.sam
   LC_ALL=C fgrep "chr3	" $SAVEPATH/${PFX}F.sam | sort -k 4,4n > $SAVEPATH/chr3F.sam
   LC_ALL=C fgrep "chr4	" $SAVEPATH/${PFX}F.sam | sort -k 4,4n > $SAVEPATH/chr4F.sam
   LC_ALL=C fgrep "chr5	" $SAVEPATH/${PFX}F.sam | sort -k 4,4n > $SAVEPATH/chr5F.sam
   LC_ALL=C fgrep "chr6	" $SAVEPATH/${PFX}F.sam | sort -k 4,4n > $SAVEPATH/chr6F.sam
   LC_ALL=C fgrep "chr7	" $SAVEPATH/${PFX}F.sam | sort -k 4,4n > $SAVEPATH/chr7F.sam
   LC_ALL=C fgrep "chr8	" $SAVEPATH/${PFX}F.sam | sort -k 4,4n > $SAVEPATH/chr8F.sam
   LC_ALL=C fgrep "chr9	" $SAVEPATH/${PFX}F.sam | sort -k 4,4n > $SAVEPATH/chr9F.sam
   LC_ALL=C fgrep "chr10	" $SAVEPATH/${PFX}F.sam | sort -k 4,4n > $SAVEPATH/chr10F.sam
   LC_ALL=C fgrep "chr11	" $SAVEPATH/${PFX}F.sam | sort -k 4,4n > $SAVEPATH/chr11F.sam
   LC_ALL=C fgrep "chr12	" $SAVEPATH/${PFX}F.sam | sort -k 4,4n > $SAVEPATH/chr12F.sam
   LC_ALL=C fgrep "chr13	" $SAVEPATH/${PFX}F.sam | sort -k 4,4n > $SAVEPATH/chr13F.sam
   LC_ALL=C fgrep "chr14	" $SAVEPATH/${PFX}F.sam | sort -k 4,4n > $SAVEPATH/chr14F.sam
   LC_ALL=C fgrep "chr15	" $SAVEPATH/${PFX}F.sam | sort -k 4,4n > $SAVEPATH/chr15F.sam
   LC_ALL=C fgrep "chr16	" $SAVEPATH/${PFX}F.sam | sort -k 4,4n > $SAVEPATH/chr16F.sam
   LC_ALL=C fgrep "chr17	" $SAVEPATH/${PFX}F.sam | sort -k 4,4n > $SAVEPATH/chr17F.sam
   LC_ALL=C fgrep "chr18	" $SAVEPATH/${PFX}F.sam | sort -k 4,4n > $SAVEPATH/chr18F.sam
   LC_ALL=C fgrep "chr19	" $SAVEPATH/${PFX}F.sam | sort -k 4,4n > $SAVEPATH/chr19F.sam
   LC_ALL=C fgrep "chr20	" $SAVEPATH/${PFX}F.sam | sort -k 4,4n > $SAVEPATH/chr20F.sam
   LC_ALL=C fgrep "chr21	" $SAVEPATH/${PFX}F.sam | sort -k 4,4n > $SAVEPATH/chr21F.sam
   LC_ALL=C fgrep "chr22	" $SAVEPATH/${PFX}F.sam | sort -k 4,4n > $SAVEPATH/chr22F.sam
   LC_ALL=C fgrep "chrX	" $SAVEPATH/${PFX}F.sam | sort -k 4,4n > $SAVEPATH/chrXF.sam
   LC_ALL=C fgrep "chrY	" $SAVEPATH/${PFX}F.sam | sort -k 4,4n > $SAVEPATH/chrYF.sam
   LC_ALL=C fgrep "chr1	" $SAVEPATH/${PFX}R.sam | sort -k 4,4n > $SAVEPATH/chr1R.sam
   LC_ALL=C fgrep "chr2	" $SAVEPATH/${PFX}R.sam | sort -k 4,4n > $SAVEPATH/chr2R.sam
   LC_ALL=C fgrep "chr3	" $SAVEPATH/${PFX}R.sam | sort -k 4,4n > $SAVEPATH/chr3R.sam
   LC_ALL=C fgrep "chr4	" $SAVEPATH/${PFX}R.sam | sort -k 4,4n > $SAVEPATH/chr4R.sam
   LC_ALL=C fgrep "chr5	" $SAVEPATH/${PFX}R.sam | sort -k 4,4n > $SAVEPATH/chr5R.sam
   LC_ALL=C fgrep "chr6	" $SAVEPATH/${PFX}R.sam | sort -k 4,4n > $SAVEPATH/chr6R.sam
   LC_ALL=C fgrep "chr7	" $SAVEPATH/${PFX}R.sam | sort -k 4,4n > $SAVEPATH/chr7R.sam
   LC_ALL=C fgrep "chr8	" $SAVEPATH/${PFX}R.sam | sort -k 4,4n > $SAVEPATH/chr8R.sam
   LC_ALL=C fgrep "chr9	" $SAVEPATH/${PFX}R.sam | sort -k 4,4n > $SAVEPATH/chr9R.sam
   LC_ALL=C fgrep "chr10	" $SAVEPATH/${PFX}R.sam | sort -k 4,4n > $SAVEPATH/chr10R.sam
   LC_ALL=C fgrep "chr11	" $SAVEPATH/${PFX}R.sam | sort -k 4,4n > $SAVEPATH/chr11R.sam
   LC_ALL=C fgrep "chr12	" $SAVEPATH/${PFX}R.sam | sort -k 4,4n > $SAVEPATH/chr12R.sam
   LC_ALL=C fgrep "chr13	" $SAVEPATH/${PFX}R.sam | sort -k 4,4n > $SAVEPATH/chr13R.sam
   LC_ALL=C fgrep "chr14	" $SAVEPATH/${PFX}R.sam | sort -k 4,4n > $SAVEPATH/chr14R.sam
   LC_ALL=C fgrep "chr15	" $SAVEPATH/${PFX}R.sam | sort -k 4,4n > $SAVEPATH/chr15R.sam
   LC_ALL=C fgrep "chr16	" $SAVEPATH/${PFX}R.sam | sort -k 4,4n > $SAVEPATH/chr16R.sam
   LC_ALL=C fgrep "chr17	" $SAVEPATH/${PFX}R.sam | sort -k 4,4n > $SAVEPATH/chr17R.sam
   LC_ALL=C fgrep "chr18	" $SAVEPATH/${PFX}R.sam | sort -k 4,4n > $SAVEPATH/chr18R.sam
   LC_ALL=C fgrep "chr19	" $SAVEPATH/${PFX}R.sam | sort -k 4,4n > $SAVEPATH/chr19R.sam
   LC_ALL=C fgrep "chr20	" $SAVEPATH/${PFX}R.sam | sort -k 4,4n > $SAVEPATH/chr20R.sam
   LC_ALL=C fgrep "chr21	" $SAVEPATH/${PFX}R.sam | sort -k 4,4n > $SAVEPATH/chr21R.sam
   LC_ALL=C fgrep "chr22	" $SAVEPATH/${PFX}R.sam | sort -k 4,4n > $SAVEPATH/chr22R.sam
   LC_ALL=C fgrep "chrX	" $SAVEPATH/${PFX}R.sam | sort -k 4,4n > $SAVEPATH/chrXR.sam
   LC_ALL=C fgrep "chrY	" $SAVEPATH/${PFX}R.sam | sort -k 4,4n > $SAVEPATH/chrYR.sam

   echo 'Done with chromosome grep' >> $SAVEPATH/$PFX.log;
   date +"%D %H:%M" >> $SAVEPATH/$PFX.log;
fi

#4) walk through mip list grep'ing for reads for each mip, calling variants
while read full_line
do
   line=$(echo $full_line | cut -d' ' -f 1);
   ranges=$(echo $full_line | cut -d' ' -f 2);
   lowarm=$(echo $full_line | cut -d' ' -f 3);
   higharm=$(echo $full_line | cut -d' ' -f 4);
   CHR=$(echo $ranges | cut -d':' -f 1);
   NT=$(echo $ranges | cut -d':' -f 2);
   NT=$(echo $NT | cut -d'-' -f 1);
   CHRT=$CHR$'\t'

   if [ $COUNTONLY != "COUNTCONTINUE" ]
   then
      echo "Starting nt grep for $line" >> $SAVEPATH/$PFX.log;
      date +"%D %H:%M" >> $SAVEPATH/$PFX.log;

      mkdir $SAVEPATH/$line
      GREPSTR="LC_ALL=C fgrep $CHRT $SAVEPATH/${CHR}F.sam | grep '$NT' | sort -t: -k 8,8  > $SAVEPATH/$line/$line.$NT.sam"
      eval $GREPSTR

      #debug data if you are looking to see if we are losing a lot of reads to the exact coordinates  look at file size of $SAVEPATH/$line/$line.$NT.sam vs $SAVEPATH/$line/$line.all
      #do this for both forward and reverse mips loops
      #NT1=$((NT+1))
      #NT2=$((NT+2))
      #NT3=$((NT+3))
      #NTR1=$((NT-1))
      #NTR2=$((NT-2))
      #NTR3=$((NT-3))
      #GREPSTR="LC_ALL=C fgrep $CHRT $SAVEPATH/${CHR}F.sam | grep '$NT3\|$NT2\|$NT1\|$NT\|$NTR1\|$NTR2\|$NTR3' | sort -k 4,4n  > $SAVEPATH/$line/$line.all"
      #eval $GREPSTR

      echo "Done nt grep for $line" >> $SAVEPATH/$PFX.log;
      date +"%D %H:%M" >> $SAVEPATH/$PFX.log;

      if [ -s "$SAVEPATH/$line/$line.$NT.sam" ]
      then
         perl $SPLIT_MIPS_READS/remove_singles.pl $SAVEPATH/$line/$line.$NT.sam $SAVEPATH/${PFX}_mip_counts.txt
      else
         perl $SPLIT_MIPS_READS/empty_sam.pl $SAVEPATH/$line/$line.$NT.sam $SAVEPATH/${PFX}_mip_counts.txt
      fi
   fi
   if [ $COUNTONLY != "COUNTONLY" ]
   then
      if [ -s "$SAVEPATH/$line/$line.$NT.sam" ]
         then
         perl $SPLIT_MIPS_READS/add_RX_field.pl  $SAVEPATH/$line/$line.$NT.sam.nosingles
         cat $SPLIT_MIPS_READS/dict.sam $SAVEPATH/$line/$line.$NT.sam.nosingles.RX > $SAVEPATH/$line/$line.$NT.sam.nosingles.RX_withheader.sam
         java -Xmx1g -jar $FGBIO CallMolecularConsensusReads --input=$SAVEPATH/$line/$line.$NT.sam.nosingles.RX_withheader.sam --output=$SAVEPATH/$line/$line.$NT.sam.nosingles.RX_withheader_con.sam --error-rate-post-umi=30 --min-reads=2 --min-input-base-quality 20
#	 $SING_DATA /mnt/disk4/labs/salipante/programs/sing_images/samtools-1.2.simg samtools view -u -b -S $SAVEPATH/$line/$line.$NT.sam.nosingles.RX_withheader_con.sam | $SING_DATA /mnt/disk4/labs/salipante/programs/sing_images/samtools-1.2.simg samtools  sort '-' $SAVEPATH/$line/$line.$NT.sam.nosingles.RX_withheader_con
         $SAMTOOLS_ROOT/samtools view -u -b -S $SAVEPATH/$line/$line.$NT.sam.nosingles.RX_withheader_con.sam | $SAMTOOLS_ROOT/samtools sort '-' $SAVEPATH/$line/$line.$NT.sam.nosingles.RX_withheader_con
#         $SING_DATA /mnt/disk4/labs/salipante/programs/sing_images/samtools-1.2.simg samtools index $SAVEPATH/$line/$line.$NT.sam.nosingles.RX_withheader_con.bam
         $SAMTOOLS_ROOT/samtools index $SAVEPATH/$line/$line.$NT.sam.nosingles.RX_withheader_con.bam
#         SING=" singularity exec --bind $(pwd) --pwd $(pwd)"
#         $SING /mnt/disk4/labs/salipante/programs/sing_images/picard-2.18.16.simg java -Dpicard.useLegacyParser=false -jar /opt/picard.jar SamToFastq I=$SAVEPATH/$line/$line.$NT.sam.nosingles.RX_withheader_con.bam F=$SAVEPATH/$line/$line.$NT.fastq 2>> $SAVEPATH/$PFX.log;
         java -Xmx1g -jar $PICARD SamToFastq I=$SAVEPATH/$line/$line.$NT.sam.nosingles.RX_withheader_con.bam F=$SAVEPATH/$line/$line.$NT.fastq
         mv $SAVEPATH/$line/$line.$NT.sam $SAVEPATH/$line/$line.$NT.initial.sam
#	 $SING_DATA /mnt/disk4/labs/salipante/programs/sing_images/bwa-0.7.12.img mem -p -t 8 $REFERENCE_GENOME $SAVEPATH/$line/$line.$NT.fastq > $SAVEPATH/$line/$line.$NT.sam
         $BWA_ROOT/bwa mem -p -t 8 $REFERENCE_GENOME $SAVEPATH/$line/$line.$NT.fastq > $SAVEPATH/$line/$line.$NT.sam
#         $SING_DATA /mnt/disk4/labs/salipante/programs/sing_images/samtools-1.2.simg samtools view -u -b -S $SAVEPATH/$line/$line.$NT.sam | $SING_DATA /mnt/disk4/labs/salipante/programs/sing_images/samtools-1.2.simg samtools  sort '-' $SAVEPATH/$line/$line.$NT
	 $SAMTOOLS_ROOT/samtools view -u -b -S $SAVEPATH/$line/$line.$NT.sam | $SAMTOOLS_ROOT/samtools sort '-' $SAVEPATH/$line/$line.$NT
#         $SING_DATA /mnt/disk4/labs/salipante/programs/sing_images/samtools-1.2.simg samtools index $SAVEPATH/$line/$line.$NT.bam
         $SAMTOOLS_ROOT/samtools index $SAVEPATH/$line/$line.$NT.bam
#         $SING_DATA /mnt/disk4/labs/salipante/programs/sing_images/samtools-1.2.simg samtools mpileup -F 0.2 -f $REFERENCE_GENOME  -d 100000 $SAVEPATH/$line/$line.$NT.bam > $SAVEPATH/$line/$line.$NT.mpileup
         $SAMTOOLS_ROOT/samtools mpileup -F 0.2 -f $REFERENCE_GENOME  -d 100000 $SAVEPATH/$line/$line.$NT.bam > $SAVEPATH/$line/$line.$NT.mpileup
         perl $SPLIT_MIPS_READS/call_variants_from_mpileup.pl $SAVEPATH/$line/$line.$NT.mpileup '0' $SAVEPATH/$line/$line.$NT.vcf
      fi

      #move initial sam files away, when working rm them
      grep chr $SAVEPATH/$line/$line.$NT.vcf | sort -k 2,2n -k 4,4 -k 5,5 > $SAVEPATH/$line/complete.vcf.unmodded
      mv $SAVEPATH/$line/$line.$NT.vcf $SAVEPATH/$line/$line.$NT.vcf.initial
      lines_in_vcf=`wc -l $SAVEPATH/$line/complete.vcf.unmodded`
      lines_in_vcf=${lines_in_vcf:0:1}

      if [ -s "$SAVEPATH/$line/$line.$NT.sam.nosingles.RX_withheader_con.sam" ]
      then
         moletag_count=`wc -l $SAVEPATH/$line/$line.$NT.sam.nosingles.RX_withheader_con.sam | cut -d " " -f1`
         let moletag_count=$moletag_count-3; #three header lines
      else
        moletag_count=0
      fi
      echo "moletag count for $line was $moletag_count";

      if [ $lines_in_vcf == "0" ]
      then
         echo "No variants found for $DIRECTORY/${line}/complete.vcf.unmodded, $moletag_count tagcount"
         #create dummy vcf to keep moletag_count
         echo "##fileformat=VCFv4.1" > $SAVEPATH/$line/complete.final.vcf
         echo "##FORMAT=<ID=GT,Number=1,Type=String,Description=\"Genotype\">" >> $SAVEPATH/$line/complete.final.vcf
         echo "##FORMAT=<ID=ALT,Number=1,Type=Integer,Description=\"Number of alts found\">" >> $SAVEPATH/$line/complete.final.vcf
         echo "##FORMAT=<ID=TOT,Number=1,Type=Integer,Description=\"total number of molecular tags at this location\">" >> $SAVEPATH/$line/complete.final.vcf
         echo "##FORMAT=<ID=FRAC,Number=1,Type=Float,Description=\"fraction of alt alleles compared to total molecular tags at this location\">" >> $SAVEPATH/$line/complete.final.vcf
         echo "#CHROM  POS     ID      REF     ALT     QUAL    FILTER  INFO    FORMAT  Sample1" >> $SAVEPATH/$line/complete.final.vcf
         let "lowarm++"
         echo -e "$CHR\t$lowarm\t.\tX\tX\t.\tPASS\t.\tGT:ALT:TOT:FRAC\t1:0:$moletag_count:0.0" >> $SAVEPATH/$line/complete.final.vcf
      else
         perl $SPLIT_MIPS_READS/simplify_vcfs.pl $lowarm $higharm $SAVEPATH/$line/complete.vcf.unmodded $moletag_count $SAVEPATH/$line/complete.final.vcf
      fi
   fi

done < $RANGES_FILE

while read full_line
do
   line=$(echo $full_line | cut -d' ' -f 1);
   ranges=$(echo $full_line | cut -d' ' -f 2);
   lowarm=$(echo $full_line | cut -d' ' -f 3);
   higharm=$(echo $full_line | cut -d' ' -f 4);
   CHR=$(echo $ranges | cut -d':' -f 1);
   NT=$(echo $ranges | cut -d':' -f 2);
   NT=$(echo $NT | cut -d'-' -f 1);
   CHRT=$CHR$'\t'

   if [ $COUNTONLY != "COUNTCONTINUE" ]
   then
      echo "Starting nt grep for $line" >> $SAVEPATH/$PFX.log;
      date +"%D %H:%M" >> $SAVEPATH/$PFX.log;

      mkdir $SAVEPATH/$line
      GREPSTR="LC_ALL=C fgrep $CHRT $SAVEPATH/${CHR}R.sam | grep '$NT' | sort -t: -k 8,8  > $SAVEPATH/$line/$line.$NT.sam"
      eval $GREPSTR

      #debug data if you are looking to see if we are losing a lot of reads to the exact coordinates  look at file size of $SAVEPATH/$line/$line.$NT.sam vs $SAVEPATH/$line/$line.all
      #do this for both forward and reverse mips loops
      #NT1=$((NT+1))
      #NT2=$((NT+2))
      #NT3=$((NT+3))
      #NTR1=$((NT-1))
      #NTR2=$((NT-2))
      #NTR3=$((NT-3))
      #GREPSTR="LC_ALL=C fgrep $CHRT $SAVEPATH/${CHR}R.sam | grep '$NT3\|$NT2\|$NT1\|$NT\|$NTR1\|$NTR2\|$NTR3' | sort -k 4,4n  > $SAVEPATH/$line/$line.all"
      #eval $GREPSTR

      echo "Done nt grep for $line" >> $SAVEPATH/$PFX.log;
      date +"%D %H:%M" >> $SAVEPATH/$PFX.log;

      if [ -s "$SAVEPATH/$line/$line.$NT.sam" ]
      then
         perl $SPLIT_MIPS_READS/remove_singles.pl $SAVEPATH/$line/$line.$NT.sam $SAVEPATH/${PFX}_mip_counts.txt
      else
         perl $SPLIT_MIPS_READS/empty_sam.pl $SAVEPATH/$line/$line.$NT.sam $SAVEPATH/${PFX}_mip_counts.txt
      fi
   fi
   if [ $COUNTONLY != "COUNTONLY" ]
   then
      if [ -s "$SAVEPATH/$line/$line.$NT.sam" ]
      then
         perl $SPLIT_MIPS_READS/add_RX_field.pl  $SAVEPATH/$line/$line.$NT.sam.nosingles
         cat $SPLIT_MIPS_READS/dict.sam $SAVEPATH/$line/$line.$NT.sam.nosingles.RX > $SAVEPATH/$line/$line.$NT.sam.nosingles.RX_withheader.sam
         java -Xmx1g -jar $FGBIO CallMolecularConsensusReads --input=$SAVEPATH/$line/$line.$NT.sam.nosingles.RX_withheader.sam --output=$SAVEPATH/$line/$line.$NT.sam.nosingles.RX_withheader_con.sam --error-rate-post-umi=30 --min-reads=2 --min-input-base-quality 20
#         $SING_DATA /mnt/disk4/labs/salipante/programs/sing_images/samtools-1.2.simg samtools view -u -b -S $SAVEPATH/$line/$line.$NT.sam.nosingles.RX_withheader_con.sam | $SING_DATA /mnt/disk4/labs/salipante/programs/sing_images/samtools-1.2.simg samtools  sort '-' $SAVEPATH/$line/$line.$NT.sam.nosingles.RX_withheader_con
         $SAMTOOLS_ROOT/samtools view -u -b -S $SAVEPATH/$line/$line.$NT.sam.nosingles.RX_withheader_con.sam | $SAMTOOLS_ROOT/samtools sort '-' $SAVEPATH/$line/$line.$NT.sam.nosingles.RX_withheader_con
#         $SING_DATA /mnt/disk4/labs/salipante/programs/sing_images/samtools-1.2.simg samtools index $SAVEPATH/$line/$line.$NT.sam.nosingles.RX_withheader_con.bam
         $SAMTOOLS_ROOT/samtools index $SAVEPATH/$line/$line.$NT.sam.nosingles.RX_withheader_con.bam
#         $SING /mnt/disk4/labs/salipante/programs/sing_images/picard-2.18.16.simg java -Dpicard.useLegacyParser=false -jar /opt/picard.jar SamToFastq I=$SAVEPATH/$line/$line.$NT.sam.nosingles.RX_withheader_con.bam F=$SAVEPATH/$line/$line.$NT.fastq 2>> $SAVEPATH/$PFX.log;
         java -Xmx1g -jar $PICARD SamToFastq I=$SAVEPATH/$line/$line.$NT.sam.nosingles.RX_withheader_con.bam F=$SAVEPATH/$line/$line.$NT.fastq
         mv $SAVEPATH/$line/$line.$NT.sam $SAVEPATH/$line/$line.$NT.initial.sam
#         $SING_DATA /mnt/disk4/labs/salipante/programs/sing_images/bwa-0.7.12.img mem -p -t 8 $REFERENCE_GENOME $SAVEPATH/$line/$line.$NT.fastq > $SAVEPATH/$line/$line.$NT.sam
         $BWA_ROOT/bwa mem -p -t 8 $REFERENCE_GENOME $SAVEPATH/$line/$line.$NT.fastq > $SAVEPATH/$line/$line.$NT.sam
#         $SING_DATA /mnt/disk4/labs/salipante/programs/sing_images/samtools-1.2.simg samtools view -u -b -S $SAVEPATH/$line/$line.$NT.sam | $SING_DATA /mnt/disk4/labs/salipante/programs/sing_images/samtools-1.2.simg samtools  sort '-' $SAVEPATH/$line/$line.$NT
	 $SAMTOOLS_ROOT/samtools view -u -b -S $SAVEPATH/$line/$line.$NT.sam | $SAMTOOLS_ROOT/samtools sort '-' $SAVEPATH/$line/$line.$NT
#         $SING_DATA /mnt/disk4/labs/salipante/programs/sing_images/samtools-1.2.simg samtools index $SAVEPATH/$line/$line.$NT.bam
         $SAMTOOLS_ROOT/samtools index $SAVEPATH/$line/$line.$NT.bam
#         $SING_DATA /mnt/disk4/labs/salipante/programs/sing_images/samtools-1.2.simg samtools mpileup -F 0.2 -f $REFERENCE_GENOME  -d 100000 $SAVEPATH/$line/$line.$NT.bam > $SAVEPATH/$line/$line.$NT.mpileup
         $SAMTOOLS_ROOT/samtools mpileup -F 0.2 -f $REFERENCE_GENOME  -d 100000 $SAVEPATH/$line/$line.$NT.bam > $SAVEPATH/$line/$line.$NT.mpileup
         perl $SPLIT_MIPS_READS/call_variants_from_mpileup.pl $SAVEPATH/$line/$line.$NT.mpileup '0' $SAVEPATH/$line/$line.$NT.vcf
      fi
      #move initial sam files away, when working rm them
      grep chr $SAVEPATH/$line/$line.$NT.vcf | sort -k 2,2n -k 4,4 -k 5,5 > $SAVEPATH/$line/complete.vcf.unmodded
      mv $SAVEPATH/$line/$line.$NT.vcf $SAVEPATH/$line/$line.$NT.vcf.initial
      lines_in_vcf=`wc -l $SAVEPATH/$line/complete.vcf.unmodded`
      lines_in_vcf=${lines_in_vcf:0:1}

      if [ -s "$SAVEPATH/$line/$line.$NT.sam.nosingles.RX_withheader_con.sam" ]
      then
         moletag_count=`wc -l $SAVEPATH/$line/$line.$NT.sam.nosingles.RX_withheader_con.sam | cut -d " " -f1`
         let moletag_count=$moletag_count-3; #three header lines
      else
         moletag_count=0
      fi
      echo "moletag count for $line was $moletag_count";

      if [ $lines_in_vcf == "0" ]
      then
         echo "No variants found for $DIRECTORY/${line}/complete.vcf.unmodded, $moletag_count tagcount"
         #create dummy vcf to keep moletag_count
         echo "##fileformat=VCFv4.1" > $SAVEPATH/$line/complete.final.vcf
         echo "##FORMAT=<ID=GT,Number=1,Type=String,Description=\"Genotype\">" >> $SAVEPATH/$line/complete.final.vcf
         echo "##FORMAT=<ID=ALT,Number=1,Type=Integer,Description=\"Number of alts found\">" >> $SAVEPATH/$line/complete.final.vcf
         echo "##FORMAT=<ID=TOT,Number=1,Type=Integer,Description=\"total number of molecular tags at this location\">" >> $SAVEPATH/$line/complete.final.vcf
         echo "##FORMAT=<ID=FRAC,Number=1,Type=Float,Description=\"fraction of alt alleles compared to total molecular tags at this location\">" >> $SAVEPATH/$line/complete.final.vcf
         echo "#CHROM  POS     ID      REF     ALT     QUAL    FILTER  INFO    FORMAT  Sample1" >> $SAVEPATH/$line/complete.final.vcf
         let "lowarm++"
         echo -e "$CHR\t$lowarm\t.\tX\tX\t.\tPASS\t.\tGT:ALT:TOT:FRAC\t1:0:$moletag_count:0.0" >> $SAVEPATH/$line/complete.final.vcf
      else
         perl $SPLIT_MIPS_READS/simplify_vcfs.pl $lowarm $higharm $SAVEPATH/$line/complete.vcf.unmodded $moletag_count $SAVEPATH/$line/complete.final.vcf
      fi
      mv $SAVEPATH/$line/complete.final.vcf $SAVEPATH/$line/complete.final.vcfR
   fi
done < ${RANGES_FILE}R

