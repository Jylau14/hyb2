#!/bin/bash

#input -c {*.hyb/_structure_coordinates.txt} -s {*.hyb/.basepair_scores.txt} -p input.hyb

while getopts "c:s:p:" OPTION
do
     case $OPTION in
         c) COORD=$OPTARG ;;
         s) SCORE=$OPTARG ;;
         p) PREFIX=$OPTARG ;;
         ?)
             echo "incorrect option"
             exit 0
             ;;
     esac
done

cat $COORD | while read nm c1 c2 c3 ; do
echo NAME $nm
echo C1 $c1
echo C2 $c2
echo C3 $c3
cat $nm | awk -v OFFSET=$c1 'NR==1{print $1 "\t" $5}$1<$5 && NR>1{print $1+OFFSET "\t" $5+OFFSET}' > ${nm/.ct/.bps}
if [ -z $PREFIX ] 
then
	make_VARNA_scores_2.sh -m 1000000 -l $c2 -t $c3 -i $SCORE -b ${nm/.ct/.bps}
else
	make_VARNA_scores_2.sh -m 1000000 -l $c2 -t $c3 -i $SCORE -b ${nm/.ct/.bps} -p ${PREFIX/.hyb/}
fi
done

