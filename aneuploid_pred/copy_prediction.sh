#!/bin/bash

#command line arguments
while getopts f:s:r:m:M option
do
	case "${option}"
	in
	f) FILE=$OPTARG;;
	s) SAMPLE=$OPTARG;;
	r) REF=$OPTARG;;
	m) COPYMIN=$OPTARG;;
	M) COPYMAX=$OPTARG;;
	esac
done

#get sample coverages from input file
COV=$(grep -w "$SAMPLE" ../input/"$FILE")

#get individual chromosome coverages
echo "$COV" | cut -f4-16 > "$SAMPLE"_extr.txt

#get number of chromosomes
CHRN=$(awk '{print NF-3; exit}' ../input/"$FILE")
echo "$CHRN"

awk -v OFS="," '$1=$1' ""$SAMPLE"_extr.txt" > "$SAMPLE"_array.txt

SAMPARR=$(cat "$SAMPLE"_array.txt)

#get total coverage for reference
REFROW=$(grep -w "$REF" ../input/"$FILE")
NUM1=$(echo "$REFROW" | cut -f2)
NUM2=$(echo "$REFROW" | cut -f3)
TOT=$(("$NUM1" + "$NUM2"))
#REFCOV=$(grep -w "$REF" ../input/"$FILE")
#TOT=0
#for i in {1..13}
#do
	#NUM"$i"=$(echo "$REFCOV" | cut -f"$i")
	#TOT=$(("$TOT" + "$NUM""$i"))
#done

#get coverage array for reference for each chromosome
echo "$REFROW" | cut -f4-16 > "$REF"_extr.txt
awk -v OFS="," '$1=$1' ""$REF"_extr.txt" > "$REF"_array.txt

REFARR=$(cat "$REF"_array.txt)
rm "$SAMPLE"_*.txt
rm "$REF"_*.txt

#run python script to get optimal copy number
python copy_prediction.py "$CHRN" "$TOT" "$SAMPARR" "$REFARR" "$COPYMIN" "$COPYMAX"


awk '$1="'$SAMPLE'	"$1' optimal_combination.txt > ../results/refAsue/capped2/Assembly_v2/merged_seqs/optimal.txt
rm optimal_combination.txt

#for single copy combinations:
TEST=$(grep -w "skipped" obs_exp.txt)
if [ "$TEST" != "skipped" ]
then

	cat obs_exp.txt | tr "][" "\n" > obs_expsep.txt
	grep -w -v "(" obs_expsep.txt | grep -w -v "," | grep -w -v ")" > obs_exptable.txt
	awk -v OFS="\t" '$1=$1' obs_exptable.txt > obs_exptable_tab_1.txt

	one=$(echo 1)
	for i in $(seq 1 "$CHRN")
	do
		n=$(($i + $one))
		awk -F"\t" -v OFS="\t" '{gsub(",","",$'$i')}1' obs_exptable_tab_"$i".txt > obs_exptable_tab_"$n".txt
	done

	mv obs_exptable_tab_"$n".txt R_input.txt
	rm obs_exp*
	#run R script obs-exp.R to generate plot of observed vs expected for optimal copy number
	Rscript obs-exp.R ../results/plots/capped2/Assembly_v2/merged_seqs/"$SAMPLE"_"$COPYMIN"_"$COPYMAX"
	rm R_input.txt
fi
