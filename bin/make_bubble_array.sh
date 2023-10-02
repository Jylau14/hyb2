#!/bin/bash -e

# parsing command line options
while getopts "i:f:" OPTION
do
     case $OPTION in
         i) IN_SCORE=$OPTARG ;;
         f) IN_FASTA=$OPTARG ;;
         ?)

             echo "incorrect option"
             exit 0
             ;;
     esac
done

NAME=${IN_SCORE/.basepair_scores.txt/__$IN_FASTA}
OUTPUT=${IN_SCORE/.basepair_scores.txt/}

#extracting folding energy column
awk '{print FILENAME"\t"$2}' *dG | awk 'FNR %2 == 0' > all_energy.txt
paste all_names_scores.txt all_energy.txt > all_names_scores_energy.txt
cat all_names_scores_energy.txt | awk '{print $1"\t"$2"\t"$4}' | sed "s/$NAME//g;s/.VARNA_scores.txt//g" | sort -k1,1n > $OUTPUT"_scores_dG_sorted.txt"

#making Ct_array with *fasta[0-9]* as header, cut 1st column
for f in *[0-9].ct; do awk 'FNR==1 {split(FILENAME,a,".ct");$5=a[1]}1' $f > ${f/.ct/_named.ct}; done
awk '{ a[FNR] = (a[FNR] ? a[FNR] FS : "") $5 } END { for(i=1;i<=FNR;i++) print a[i] }' $(ls -1v *[0-9]_named.ct) |  awk '{print NR-1 "\t" $0}' > Ct_files_array
cut -f2- Ct_files_array > $OUTPUT"_ct_array"
rm *named.ct

