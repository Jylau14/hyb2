#!/bin/bash -e
#collapses reads by GENE NAME and MAPPED SEQUENCE, tallying reads to the ID
#only reads with at least 2 counts are printed
sort -k2 $1 | awk '{if (NR==1){n=0; a[n]=$0}; if ($2==l2){a[++n]=$0} else{for (l in a){print n"\t"a[l];}; n=0; delete a}; l2=$2; l=$0}; END{if (l2=$2){print n"\t"$0}}' | awk '{split($2,a,"_"); print a[1]"_"a[2]+$1"\t"$0}' | cut --complement -f2,3 > ${1/.hyb/.temp.hyb}
#replace first line with second line, append reads with only 1 count, and remove duplicates
sed -n '2p' ${1/.hyb/.temp.hyb} > ${1/.hyb/.count.hyb}
cat ${1/.hyb/.temp.hyb} >> ${1/.hyb/.count.hyb}
cat $1 >> ${1/.hyb/.count.hyb}
awk '!seen[$2] {print}; {++seen[$2]}' ${1/.hyb/.count.hyb}

