#!/usr/bin/perl

## perl empty_sam.pl <sam file> <outfile>
## writes a line of zeros into the outfile in the case that a sam file is empty 

use warnings;
use strict;

my $file = $ARGV[0];
my $outfile = $ARGV[1];

open(OUT_COUNT, ">>", "$outfile");

my @mip_split= split("\/", $file);
my $mip_name = $mip_split[7];

print OUT_COUNT "$mip_name";

print OUT_COUNT "\t0\t0\t0\t0\t0\t0\t0\t0\t0\t0\t0\t0\t0\t0\t0\t0\t0\t0\t0\t0\t0\t0\t0\t0\t0\t0\t0\t0\t0\t0\t0\t0\t0\t0\t0\t0\t0\t0\t0\t0\t0\t0\t0\t0\t0\t0\t0\t0\t0\t0\t0\t0\t0\n";

close OUT_COUNT;

exit;

