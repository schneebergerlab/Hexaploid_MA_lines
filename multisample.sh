#!/bin/bash
#command line arguments
while getopts i:g:a:b: option
do
	case "${option}"
	in
	i)FILE=$OPTARG;;
	g)REF=$OPTARG;;
	a)MIN=$OPTARG;;
	b)MAX=$OPTARG;;
	esac
done

#get all sample names in input file
grep -w -v "$REF" ../input/"$FILE" | cut -f1 > samples.merged.Asue.0909.txt

#remove header
#sed -i '1d' all_samples.txt

#run copy prediction program for each sample and generate R plots
#generate table of optimal copy combinations for the samples
filename='samples.merged.Asue.0909.txt'
filelines=`cat $filename`
for line in $filelines; do
	./copy_prediction.sh -f "$FILE" -s "$line" -r "$REF" -m "$MIN" -M "$MAX"
	cat ../results/refAsue/capped2/Assembly_v2/merged_seqs/optimal.txt >> ../results/refAsue/capped2/Assembly_v2/merged_seqs/"$FILE"_"$MIN"_"$MAX".txt
	
done

rm ../results/refAsue/capped2/Assembly_v2/merged_seqs/optimal.txt samples.merged.Asue.0909.txt

