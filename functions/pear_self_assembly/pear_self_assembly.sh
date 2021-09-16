#!/bin/bash

#here's how to install pear to local directory
#cd wherever/PEAR-master
#./autogen.sh
#./configure --prefix=location/to/save/pear
#make
#make install

#PEAR="/home/molmicro/genome/pear/bin/pear"#plop this in to functions source

SAVEPATH_ROOT=$1;
R1=$2;
R2=$3;
PFX=$4;
SAVEPATH=$5
MIN_LENGTH=$6
CORES=$7

SALIPANTE_ROOT=$(cat $SAVEPATH_ROOT/config.txt);
source $SALIPANTE_ROOT/code/source.sh $SALIPANTE_ROOT;

mkdir -p $SAVEPATH;

echo 'Assemble overlapping reads with PEAR' >> $SAVEPATH/$PFX.log; 
date +"%D %H:%M" >> $SAVEPATH/$PFX.log;

gunzip $R1;
gunzip $R2;

#remove file extension
R1_unzipped=${R1%.gz}  
R2_unzipped=${R2%.gz}  

#assemble reads using PEAR
$PEAR -f $R1_unzipped -r $R2_unzipped -o $SAVEPATH/$PFX -n $MIN_LENGTH -j $CORES > $SAVEPATH/$PFX.assemble_reads.log; 

#zip up reads that were created
gzip $SAVEPATH/$PFX.*.fastq 

echo 'Assemble with PEAR complete' >> $SAVEPATH/$PFX.log;
date +"%D %H:%M" >> $SAVEPATH/$PFX.log;
