#!/bin/bash

# usage:
# make_VARNA_scores.sh -s text -m 100 -l 3000 -t 1500 -i in.basepair_scores.txt -b in.bps

SUFFIX=""

while getopts "l:i:b:t:m:s:p:" OPTION
do
     case $OPTION in
         l) LEN=$OPTARG ;;
         t) TAIL=$OPTARG ;;
         i) INPUT=$OPTARG ;;
         b) BPS=$OPTARG ;;
         m) MAX=$OPTARG ;;
         s) SUFFIX=$OPTARG ;;
         p) PREFIX=$OPTARG ;;
         ?)
             echo "incorrect option"
             exit 0
             ;;
     esac
done

awk 'NR==FNR{fnd[$1,$2]+=$3;fnd[$2,$1]+=$3}NR!=FNR && fnd[$1,$2]{print $1 "\t" $2 "\t" fnd[$1,$2]}' $INPUT $BPS > ${INPUT/basepair_scores.txt/VARNA_scores.tmp}
awk '{print $1 "\t" $3 "\n" $2 "\t" $3}' ${INPUT/basepair_scores.txt/VARNA_scores.tmp} | awk -v len=$LEN -v max=$MAX 'BEGIN{for(i=1;i<=len;i++){score[i]=0}}{score[$1]=$2}$2>max{score[$1]=max}END{for(i=1;i<=len;i++){print score[i]}}' > ${INPUT/basepair_scores.txt/VARNA_scores.tmp2}

if [ "$TAIL" -gt "0" ] && [ -z $PREFIX ] ; then
tail -n $TAIL ${INPUT/basepair_scores.txt/VARNA_scores.tmp2} > ${INPUT/.basepair_scores.txt/}"__"${BPS/.bps/}$SUFFIX".VARNA_scores.txt" 
elif [ "$TAIL" -gt "0" ] && [ ! -z $PREFIX ] ; then
tail -n $TAIL ${INPUT/basepair_scores.txt/VARNA_scores.tmp2} > $PREFIX"__"${BPS/.bps/}$SUFFIX".VARNA_scores.txt"
else
cp ${INPUT/basepair_scores.txt/VARNA_scores.tmp2} ${INPUT/.basepair_scores.txt/}"__"${BPS/.bps/}$SUFFIX".VARNA_scores.txt"
fi

rm ${INPUT/basepair_scores.txt/VARNA_scores.tmp}
rm ${INPUT/basepair_scores.txt/VARNA_scores.tmp2}


