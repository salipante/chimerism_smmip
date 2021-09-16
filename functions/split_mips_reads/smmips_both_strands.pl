#!/usr/bin/perl

## Adam Waalkes
## Usage:
## perl smmips_both_strands.pl <vcf1> <vcf2>  
## compares chromosome, position reference and alt alelle to check to see if identical
## creates three files $file1.same.vcf with matching lines from each file combining alt and total counts
## 1.vcf with the varaints unique to the first vcf and
## 2.vcf with the varaints unique to the second vcf

use warnings;
use strict;

my $vcf_file = $ARGV[0];
my $vcf_file2 = $ARGV[1];
my $vcf_out = $ARGV[2];
my $one=0;
my $two=0;
my $onemax=0;
my $twomax=0;
my $oneheaderlines=0;
my $twoheaderlines=0;
my $matchcount=0;

open(IP, "$vcf_file");
my(@line) = <IP>;
open(IP2, "$vcf_file2");
my(@line2) = <IP2>;

open(OUT_same, '>', "$vcf_out");
open(OUT_1, '>', "${vcf_file}_only");
open(OUT_2, '>', "${vcf_file2}_only");


$onemax=@line-1;
$twomax=@line2-1;

#skip vcf header
while(substr($line[$one],0,1) eq "#") {
   print OUT_same $line[$one];
   $one++;
   $oneheaderlines++;
}
while(substr($line2[$two],0,1) eq "#") {
   $two++;
   $twoheaderlines++;
}

while(($one <= $onemax) && ($two <= $twomax)) {
   my @line_split=();
   my @line_split2=();
   @line_split = split(/\t/,$line[$one]);
   @line_split2 = split(/\t/,$line2[$two]);
   if($line_split[0] ne $line_split2[0]) {
      if($line_split[0] gt $line_split2[0]) {
         print OUT_2 $line2[$two];
         $two++;
         next;
      }
      else {
         print OUT_1 $line[$one];
         $one++;
         next;
      }
   }
   if($line_split[1] != $line_split2[1]) {
      if($line_split[1] > $line_split2[1]) {
print "$line2[$two] $line_split[1] $line_split2[1]\n";
         print OUT_2 $line2[$two];
         $two++;
         next;
      }
      else {
print "$line[$one] $line_split[1] $line_split2[1]\n";
         print OUT_1 $line[$one];
         $one++;
         next;
      }
   }
   if($line_split[3] ne $line_split2[3]) {
      if($line_split[3] gt $line_split2[3]) {
         print OUT_2 $line2[$two];
         $two++;
         next;
      }
      else {
         print OUT_1 $line[$one];
         $one++;
         next;
      }
   }
   if($line_split[4] ne $line_split2[4]) {
      if($line_split[4] gt $line_split2[4]) {
         print OUT_2 $line2[$two];
         $two++;
         next;
      }
      else {
         print OUT_1 $line[$one];
         $one++;
         next;
      }
   }
   else {
     if($line_split[3] eq "X") { #these are matched but match at no variants, kept for mip count
        print OUT_1 $line[$one];
        print OUT_2 $line2[$two];
     }
     else {
        my @output_line_one_split = split(/\t/,$line[$one]);
        my @output_line_two_split = split(/\t/,$line2[$two]);
        my @output_line_one_counts = split(/\:/,$output_line_one_split[9]);
        my @output_line_two_counts = split(/\:/,$output_line_two_split[9]);
        my $one_alt_count = $output_line_one_counts[1];
        my $one_tot_count = $output_line_one_counts[2];
        my $two_alt_count = $output_line_two_counts[1];
        my $two_tot_count = $output_line_two_counts[2];
        my $all_alt = $one_alt_count + $two_alt_count;
        my $all_tot = $one_tot_count + $two_tot_count;
        my $new_alt_percent=$all_alt/$all_tot;

        print "match at nt $line_split[1] $line_split[3] $line_split[4]\n";
        print $line[$one];
        print $line2[$two];
        $output_line_one_split[9]="1:$one_alt_count:$one_tot_count:$two_alt_count:$two_tot_count:$all_alt:$all_tot:$new_alt_percent";
        $output_line_one_split[8]="GT:FALT:FTOT:RALT:RTOT:ALT:TOT:FRAC";
        print OUT_same "$output_line_one_split[0]\t$output_line_one_split[1]\t$output_line_one_split[2]\t$output_line_one_split[3]\t$output_line_one_split[4]\t$output_line_one_split[5]\t$output_line_one_split[6]\t$output_line_one_split[7]\t$output_line_one_split[8]\t$output_line_one_split[9]\n";
     }
     $matchcount++;
     $one++;
     $two++;
   }
}

#print any final lines at end of vcf one
while($one <= $onemax) {
   print OUT_1 $line[$one];
   $one++;
}

#print any final lines at end of vcf two
while($two <= $twomax) {
   print OUT_2 $line2[$two];
   $two++;
}

#overloading $one and $two
#$onemax zerobased so add one
$one=$onemax-$oneheaderlines+1;
$two=$twomax-$twoheaderlines+1;

print "Matchcount was $matchcount $vcf_file had $one variants $vcf_file2 had $two variants\n";

close IP;
close IP2;
close OUT_same;
close OUT_1;
close OUT_2;

exit;
