#!/usr/bin/perl
## Adam Waalkes
## takes a .sam file for that contains all the reads in the 3bp range of a MIP, splits but nt and then molecular tag
## creates a new .sam for each molecular tag
## Usage: split_sam_to_moletag.pl <full path>/mip.sam <path to output directory> <lowest nt in range>

use warnings;
use strict;

my $output_path = $ARGV[0];
my $mip = $ARGV[1];
my $first_nt = $ARGV[2];
my $current_nt=0;
my $current_moletag="";
my @array_split=();
my $initial_line="";
my $output_filename="";
my $input_filename="";
my $wordcount=0;
my $system_array="";
my @system_array_split=();

for(my $counter=$first_nt; $counter <= $first_nt+6; $counter++) {
   $input_filename = $output_path . '/' . $mip . '.' . $counter . '.sam';
#   print "input file name: $input_filename\n";
   $system_array = `wc -l $input_filename`; #check for empty sam file
   @system_array_split = split(' ',$system_array);
   $wordcount=$system_array_split[0];
#   print "word count:  $wordcount\n";
   if ($wordcount == 0) {
      print "Zero length sam file, skipping $input_filename\n";
      next;
   }
   open(IP, "$input_filename") or print "Couldn't open sam file $input_filename\n"; 
   $initial_line = <IP>;
   @array_split = split("\t",$initial_line);
   $current_moletag = (split(":",$array_split[0]))[-1];
#   print "line: $initial_line\n";
#   print "first moletag: $current_moletag\n";
   close IP;
   $output_filename = $output_path . '/' . $counter . '.' . $current_moletag . '.sam';
#   print "initial_output: $output_filename\n";
   open(IP, "$input_filename") or print "Couldn't open sam file $input_filename\n";
   open(OUT,">",$output_filename) or print "Couldn't open output file  $output_filename\n";
   print OUT "\@SQ	SN:chr1	LN:249250621\n";
   print OUT "\@SQ	SN:chr2	LN:243199373\n";
   print OUT "\@SQ	SN:chr3	LN:198022430\n";
   print OUT "\@SQ	SN:chr4	LN:191154276\n";
   print OUT "\@SQ	SN:chr5	LN:180915260\n";
   print OUT "\@SQ	SN:chr6	LN:171115067\n";
   print OUT "\@SQ	SN:chr7	LN:159138663\n";
   print OUT "\@SQ	SN:chr8	LN:146364022\n";
   print OUT "\@SQ	SN:chr9	LN:141213431\n";
   print OUT "\@SQ	SN:chr10	LN:135534747\n";
   print OUT "\@SQ	SN:chr11	LN:135006516\n";
   print OUT "\@SQ	SN:chr12	LN:133851895\n";
   print OUT "\@SQ	SN:chr13	LN:115169878\n";
   print OUT "\@SQ	SN:chr14	LN:107349540\n";
   print OUT "\@SQ	SN:chr15	LN:102531392\n";
   print OUT "\@SQ	SN:chr16	LN:90354753\n";
   print OUT "\@SQ	SN:chr17	LN:81195210\n";
   print OUT "\@SQ	SN:chr18	LN:78077248\n";
   print OUT "\@SQ	SN:chr19	LN:59128983\n";
   print OUT "\@SQ	SN:chr20	LN:63025520\n";
   print OUT "\@SQ	SN:chr21	LN:48129895\n";
   print OUT "\@SQ	SN:chr22	LN:51304566\n";
   print OUT "\@SQ	SN:chrX	LN:155270560\n";
   print OUT "\@SQ	SN:chrY	LN:59373566\n";
   print OUT "\@SQ	SN:chrM	LN:16571\n";
   print OUT "\@PG	ID:bwa	PN:bwa	VN:0.7.12-r1039	CL:/home/local/AMC/waalkes/salipante_lab/programs/bwa-0.7.12/bwa mem	/home/local/AMC/waalkes/salipante_lab/databases/hg37/hg37.fa	dummy.sam\n";
   while(my $line = <IP>) {
      @array_split = split("\t",$line);
      if ($current_moletag eq (split(":",$array_split[0]))[-1]){
         print OUT $line;
#         print "same";
      }
      else {
         close OUT;
#         print "new moletag\n";
         $current_moletag = (split(":",$array_split[0]))[-1];
         $output_filename = $output_path . '/' . $counter . '.' . $current_moletag . '.sam';
#         print "new outputfile: $output_filename\n";
         open(OUT,">",$output_filename) or print "Couldn't open output file  $output_filename\n";
         print OUT "\@SQ	SN:chr1	LN:249250621\n";
         print OUT "\@SQ	SN:chr2	LN:243199373\n";
         print OUT "\@SQ	SN:chr3	LN:198022430\n";
         print OUT "\@SQ	SN:chr4	LN:191154276\n";
         print OUT "\@SQ	SN:chr5	LN:180915260\n";
         print OUT "\@SQ	SN:chr6	LN:171115067\n";
         print OUT "\@SQ	SN:chr7	LN:159138663\n";
         print OUT "\@SQ	SN:chr8	LN:146364022\n";
         print OUT "\@SQ	SN:chr9	LN:141213431\n";
         print OUT "\@SQ	SN:chr10	LN:135534747\n";
         print OUT "\@SQ	SN:chr11	LN:135006516\n";
         print OUT "\@SQ	SN:chr12	LN:133851895\n";
         print OUT "\@SQ	SN:chr13	LN:115169878\n";
         print OUT "\@SQ	SN:chr14	LN:107349540\n";
         print OUT "\@SQ	SN:chr15	LN:102531392\n";
         print OUT "\@SQ	SN:chr16	LN:90354753\n";
         print OUT "\@SQ	SN:chr17	LN:81195210\n";
         print OUT "\@SQ	SN:chr18	LN:78077248\n";
         print OUT "\@SQ	SN:chr19	LN:59128983\n";
         print OUT "\@SQ	SN:chr20	LN:63025520\n";
         print OUT "\@SQ	SN:chr21	LN:48129895\n";
         print OUT "\@SQ	SN:chr22	LN:51304566\n";
         print OUT "\@SQ	SN:chrX	LN:155270560\n";
         print OUT "\@SQ	SN:chrY	LN:59373566\n";
         print OUT "\@SQ	SN:chrM	LN:16571\n";
         print OUT "\@PG	ID:bwa	PN:bwa	VN:0.7.12-r1039	CL:/home/local/AMC/waalkes/salipante_lab/programs/bwa-0.7.12/bwa mem	/home/local/AMC/waalkes/salipante_lab/databases/hg37/hg37.fa	dummy.sam\n";
         print OUT $line;
      }
   }    
}

close IP;
close OUT;

