#!/bin/bash
#create input hyb and fasta files for long-range comradesFold

#example code
#./lr_input.sh -i ZAFR.hyb -f ZAFR.fasta -a 3600 -b 5500 -g 500
#input for folding between 3601-4100 and 5501-5600

# parsing command line options
while getopts "i:f:a:b:g:" OPTION
do
     case $OPTION in
         i) IN_FILE=$OPTARG ;;
         f) IN_FASTA=$OPTARG ;;
         a) X_COORD=$OPTARG ;;
         b) Y_COORD=$OPTARG ;;
         g) GAP=$OPTARG;;
	 ?) 

             echo "incorrect option"
             exit 0
             ;;
     esac
done

X1=$(($X_COORD+1))
X2=$(($X_COORD+$GAP))
Y1=$(($Y_COORD+1))
Y2=$((Y_COORD+$GAP))
OUT_FILE=${IN_FILE/.hyb/_$X1-$X2"_"$Y1-$Y2.hyb}
OUT_FASTA=${IN_FASTA/.fasta/_$X1-$X2"_"$Y1-$Y2.fasta}

awk -v X1=$X1 -v X2=$X2 -v Y1=$Y1 -v Y2=$Y2 -v X_COORD=$X_COORD -v Y_COORD=$Y_COORD -v GAP=$GAP '{if ($7>=X1 && $8<=X2 && $13>=Y1 && $14<=Y2) print $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$6"\t"$7-X_COORD"\t"$8-X_COORD"\t"$9"\t"$10"\t"$11"\t"12"\t"$13-Y_COORD+GAP"\t"$14-Y_COORD+GAP; if ($13>=X1 && $14<=X2 && $7>=Y1 && $8<=Y2) print $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$6"\t"$7-Y_COORD+GAP"\t"$8-Y_COORD+GAP"\t"$9"\t"$10"\t"$11"\t"12"\t"$13-X_COORD"\t"$14-X_COORD}' $IN_FILE > $OUT_FILE

pf.pl $IN_FASTA $X1 $X2 > $OUT_FASTA
pf.pl $IN_FASTA $Y1 $Y2 >> $OUT_FASTA

awk 'NF' $OUT_FASTA | awk 'BEGIN{i=1}{line[i++]=$0}END{print line[1]"\n"line[2] line[4]}' > tmp && mv tmp $OUT_FASTA


