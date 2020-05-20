Single Sample
~~~~~~~~~~~~~

./copy_prediction.sh -f <input sample file> -s <sample name> -r <reference name> -m <minimum copy number> -M <maximum copy number>

~~~~~~~~~~~~~

example:

sample name: F
reference name: Asue

./copy_prediction.sh -f ALL_inclyAlyr.subgenome.covstat -s F -r Asue -m 2 -M 6

~~~~~~~~~~~~~

output:
1. optimal combination in standard output
2. R plot: observed vs expected plot in ../results/plots/ folder under <sample name>_<min copies>_<max copies>_plot.pdf

~~~~~~~~~~~~~
.............

Multiple Samples
~~~~~~~~~~~~~~~~

./multisample.sh -f <path to input file> -r <reference name> -m <minimum copies> -M <maximum copies>

~~~~~~~~~~~~~~~~

example:

reference name: Asue

./multisample.sh -f ALL_inclyAlyr.subgenome.covstat -r Asue -m 2 -M 6

~~~~~~~~~~~~~~~~

output:
1. Table with optimal combinations for each sample in file under ../results/<input filename>_<min copies>_<max copies>_optimal.txt
2. R plots: observed vs expected for each sample in ../results/plots/ folder under <sample name>_plot.pdf

~~~~~~~~~~~~~~~~
................
