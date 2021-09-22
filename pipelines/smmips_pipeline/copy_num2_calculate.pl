#!/usr/bin/perl

## Adam Waalkes
## Usage:
## perl copy_num2_calculate.pl <donor mipfile> <recipient mipfile> <combined mipfile> <% spike in 10 =10%> <min reads for non-zero for genotypes> <min reads for non-zero for sample>
##
## takes a given guess of how much recipient load there is and then models whether the data is consistent with that.  An output of
## 1 shows the real data is consisent with the guess you run this multiple times until you get an output that is close to but
## less than 1 and close to but greater than 1.  You can then take a weighted average of those guesses to get what we think is
## the actual recipient percentage. Relevent output is written to the <sample>.summary file
##
## note that variable names  are defined as follows: main = donor, minor = patient and combo = post transplant

use strict;
use warnings;
use bignum;

my $main = $ARGV[0];
my $minor = $ARGV[1];
my $combined = $ARGV[2];
my $output = $ARGV[3];
my $spike = $ARGV[4];
my $min_reads = $ARGV[5];
my $sample_min_reads = $ARGV[6];
my @main = ();
my @minor = ();
my @combo = ();
my $non_zero_count=0;
my $geomean_total = 1;
my @main_div_geo = ();
my @minor_div_geo = ();
my @combo_div_geo = ();
my $major_minor_average_factor=0;
my @minor_expected_value = ();
my @model = ();
my $combo_control_average=0;
my $combo_control_total=0;
my @final_answer = ();
my @final_value = ();
my @mip_name = ();
my $final_full_average=0;
my $final_spec_average=0;
my $final_full_total=0;
my $final_spec_total=0;
my $full_count=0;
my $spec_count=0;

open(MAIN, "$main");
open(MINOR, "$minor");
open(COMBO, "$combined");
open(LOW, ">", "$output.low");
my $temp_line = <MAIN>;
$temp_line = <MINOR>;
$temp_line = <COMBO>;

#calculate the major geometric mean
while(my $sample_line = <MAIN>) {
   my @sample_split = split("\t",$sample_line);
   if(($sample_split[0] eq "46D_cont_smg1_277") || ($sample_split[0] eq "47C_cont_dnmt1_328")) { #skip two bad controls
      next;
   }
   if($sample_split[51] >= $min_reads) {
      push @main, $sample_split[51];
      push @mip_name, $sample_split[0];
      $geomean_total=$geomean_total*$sample_split[51];
      $non_zero_count++;
   }
   else {
      push @main,"0";
      push @mip_name, $sample_split[0];
      if ($sample_split[51]>0) {
         print LOW "$sample_split[0] in major sample had a count of $sample_split[51], less than threshold of $min_reads.  Set to zero\n";
      }
   }
}

my $main_geomean = $geomean_total ** (1/$non_zero_count);
$non_zero_count=0;
$geomean_total=1;

#calculate the minor geometric mean
while(my $sample_line = <MINOR>) {
   my @sample_split = split("\t",$sample_line);
   if(($sample_split[0] eq "46D_cont_smg1_277") || ($sample_split[0] eq "47C_cont_dnmt1_328")) { #skip two bad controls
      next;
   } 
   if($sample_split[51] >= $min_reads) {
      push @minor, $sample_split[51];
      $geomean_total=$geomean_total*$sample_split[51];
      $non_zero_count++;
   }
   else {
      if ($sample_split[51]>0) {
         print LOW "$sample_split[0] in minor sample had a count of $sample_split[51], less than threshold of $min_reads.  Set to zero\n";
      }
      push @minor,"0";
   }
}

my $minor_geomean = $geomean_total ** (1/$non_zero_count);
$non_zero_count=0;
$geomean_total=1;

#calculate the combo geometric mean
while(my $sample_line = <COMBO>) {
   my @sample_split = split("\t",$sample_line);
   if(($sample_split[0] eq "46D_cont_smg1_277") || ($sample_split[0] eq "47C_cont_dnmt1_328")) { #skip two bad controls
      next;
   }
   if($sample_split[51] >= $sample_min_reads) {
      push @combo, $sample_split[51];
      $geomean_total=$geomean_total*$sample_split[51];
      $non_zero_count++;
   }
   else {
      push @combo,"0";
      if ($sample_split[51]>0) {
         print LOW "$sample_split[0] in combined sample had a count of $sample_split[51], less than sample threshold of $min_reads.  Set to zero\n";
      }
   }
}
my $combo_geomean = $geomean_total ** (1/$non_zero_count);
#print "main geomean $main_geomean\n";
#print "minor geomean $minor_geomean\n";
#print "combo geomean $combo_geomean\n";

close MAIN;
close MINOR;
close COMBO;
close LOW;

#normalize all reads to their geomeans
foreach my $count (@main) {
   push @main_div_geo, $count/$main_geomean;
}

foreach my $count (@minor) {
   push @minor_div_geo, $count/$minor_geomean;
}

foreach my $count (@combo) {
   push @combo_div_geo, $count/$combo_geomean;
}

#for(my $i=0;$i < 173;$i++) {
#   print "MAIN $main[$i], div geo $main_div_geo[$i] Minor $minor[$i], div geo $minor_div_geo[$i] combo $combo[$i], div geo $combo_div_geo[$i]\n";
#}

#these 14 are the controls
foreach my $count (85,86,87,88,89,90,91,92,93,94,95,170,171,172) {
   $major_minor_average_factor=$major_minor_average_factor+$main_div_geo[$count]/$minor_div_geo[$count];
#   print "$count main $main[$count] $main_div_geo[$count] minor $minor[$count] $minor_div_geo[$count]\n";
}
$major_minor_average_factor=$major_minor_average_factor/14;
#print "major_minor_average_factor $major_minor_average_factor\n";

foreach my $element (@minor_div_geo) {
   push @minor_expected_value, $element*$major_minor_average_factor;
}

for(my $i=0;$i < 173;$i++) {
   my $total= $main_div_geo[$i]*((100-$spike)/100)+$minor_expected_value[$i]*($spike/100);
#   print "main $main[$i] - $main_div_geo[$i] * (100-$spike)/100 + $minor_expected_value[$i] * ($spike/100) total is $total\n";
   push @model, $main_div_geo[$i]*((100-$spike)/100)+$minor_expected_value[$i]*($spike/100);
}

foreach my $count (85,86,87,88,89,90,91,92,93,94,95,170,171,172) {
   $combo_control_total=$combo_control_total+$combo_div_geo[$count]/$model[$count];
#   print "main $main[$count] $combo_control_total=$combo_control_total+$combo_div_geo[$count]/$model[$count]\n";
}
$combo_control_average=$combo_control_total/14;
#print "combo_control_average $combo_control_average\n";

foreach my $element (@combo_div_geo) {
   push @final_value, $element/$combo_control_average;
}

for(my $i=0;$i < 173;$i++) {
   push @final_answer, $final_value[$i]/$model[$i];
}

open(FULL, ">", "$output.full");
open(SPEC, ">", "$output.informative");
open(SKIP, ">", "$output.skip");
open(SUMM, ">", "$output.summary");
print FULL "mip\tmajor_count\tmajor/geomean\tminor\tminor/geomean\texpected_minor\tmodel\tcombo\tcombo/geomean\tvalue\t%expected\n";
print SPEC "mip\tmajor_count\tmajor/geomean\tminor\tminor/geomean\texpected_minor\tmodel\tcombo\tcombo/geomean\tvalue\t%expected\n";
for(my $i=0;$i < 173;$i++) {
   if(($i == 85) ||
      ($i == 86) ||
      ($i == 87) ||
      ($i == 88) ||
      ($i == 89) ||
      ($i == 90) ||
      ($i == 91) ||
      ($i == 92) ||
      ($i == 93) ||
      ($i == 94) ||
      ($i == 95) ||
      ($i == 170) ||
      ($i == 171) ||
      ($i == 172)) {
      print SKIP "$mip_name[$i]\t$main[$i]\t$main_div_geo[$i]\t$minor[$i]\t$minor_div_geo[$i]\t$minor_expected_value[$i]\t$model[$i]\t$combo[$i]\t$combo_div_geo[$i]\t$final_value[$i]\t$final_answer[$i]\n";
      next;
   }
   if(($main[$i] == 0) && ($minor[$i] == 0)) { # || ($i ~~ [85,86,87,88,89,90,91,92,93,94,95,170,171,172])) {
      print SKIP "$mip_name[$i]\t$main[$i]\t$main_div_geo[$i]\t$minor[$i]\t$minor_div_geo[$i]\t$minor_expected_value[$i]\t$model[$i]\t$combo[$i]\t$combo_div_geo[$i]\t$final_value[$i]\t$final_answer[$i]\n";
   }
   elsif ($main[$i] == 0) {
      print SPEC "$mip_name[$i]\t$main[$i]\t$main_div_geo[$i]\t$minor[$i]\t$minor_div_geo[$i]\t$minor_expected_value[$i]\t$model[$i]\t$combo[$i]\t$combo_div_geo[$i]\t$final_value[$i]\t$final_answer[$i]\n";
      print FULL "$mip_name[$i]\t$main[$i]\t$main_div_geo[$i]\t$minor[$i]\t$minor_div_geo[$i]\t$minor_expected_value[$i]\t$model[$i]\t$combo[$i]\t$combo_div_geo[$i]\t$final_value[$i]\t$final_answer[$i]\n";
      $final_full_total+=$final_answer[$i];
      $final_spec_total+=$final_answer[$i];
      $full_count++;
      $spec_count++;
   }
   else {
      print FULL "$mip_name[$i]\t$main[$i]\t$main_div_geo[$i]\t$minor[$i]\t$minor_div_geo[$i]\t$minor_expected_value[$i]\t$model[$i]\t$combo[$i]\t$combo_div_geo[$i]\t$final_value[$i]\t$final_answer[$i]\n";
      $final_full_total+=$final_answer[$i];
      $full_count++;
   }
}

$final_full_average=$final_full_total/$full_count;
$final_spec_average=$final_spec_total/$spec_count;
#print SUMM "$full_count\t$final_full_average\n";
print SUMM "$spike\t$spec_count\t$final_spec_average\n";
print SUMM "$spike\t$full_count\t$final_full_average\tfull\n";
#print SUMM "$full_count in full set with an average difference from the model of $final_full_average\n";
#print SUMM "$spec_count in set of mips with 0 major and non zero minor with an average difference from the model of $final_spec_average\n";

close SUMM;
close SKIP;
close FULL;
close SPEC;
exit;
