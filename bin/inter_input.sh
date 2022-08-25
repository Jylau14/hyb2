#!/bin/bash

#create input hyb and fasta files for comrades RNA folding between 2 independent RNA strands
#example code: input for folding between U8 homodimers
#inter_input.sh -i true_U8_homodimers.hyb -a U8-extend -b U8-extend -1 U8_extend.fasta -2 U8_extend.fasta -x 1 -y 1 -l 261
#if GENE_1 sequence length > GENE_2, -a GENE_1 -1 FASTA_1
#LEN=length of fragment for folding

# parsing command line options
while getopts "i:a:b:1:2:x:y:l:" OPTION
do
	case $OPTION in
		i) IN_FILE=$OPTARG ;;
		a) GENE_1=$OPTARG ;;
		b) GENE_2=$OPTARG ;;
		1) FASTA_1=$OPTARG ;;
		2) FASTA_2=$OPTARG ;;
		x) X_COORD=$OPTARG ;;
		y) Y_COORD=$OPTARG ;;
		l) LEN=$OPTARG ;;
		?) 

		echo "incorrect option"
		exit 0
		;;
	esac
done

#filtering data, defining start and end positions
sed -n "/$GENE_1/p" $IN_FILE | sed -n "/$GENE_2/p" > ${IN_FILE/.hyb/_$GENE_1"_"$GENE_2.hyb}
X1=$(($X_COORD))
X2=$(($X_COORD+$LEN-1))
Y1=$(($Y_COORD))
Y2=$(($Y_COORD+$LEN-1))
OUT_FILE=${IN_FILE/.hyb/_$GENE_1"-"$X1-$X2"_"$GENE_2"-"$Y1-$Y2.hyb}
OUT_FASTA=$GENE_1"-"$X1-$X2"_"$GENE_2"-"$Y1-$Y2.fasta

#transforming hyb data
#awk -v GENE_1=$GENE_1 -v GENE_2=$GENE_2 -v X1=$X1 -v X2=$X2 -v Y1=$Y1 -v Y2=$Y2 -v X_COORD=$X_COORD -v Y_COORD=$Y_COORD -v LEN=$LEN '{if ($4~GENE_1 && $7>=X1 && $8<=X2 && $10~GENE_2 && $13>=Y1 && $14<=Y2) print $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$6"\t"$7-X_COORD+1"\t"$8-X_COORD+1"\t"$9"\t"$10"\t"$11"\t"12"\t"$13-Y_COORD+LEN+101"\t"$14-Y_COORD+LEN+101; if ($10~GENE_1 && $13>=X1 && $14<=X2 && $4~GENE_2 && $7>=Y1 && $8<=Y2 && GENE_1!=GENE_2) print $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$6"\t"$7-Y_COORD+LEN+101"\t"$8-Y_COORD+LEN+101"\t"$9"\t"$10"\t"$11"\t"12"\t"$13-X_COORD+1"\t"$14-X_COORD+1}' $IN_FILE > TEMP.hyb
#sed "s/$GENE_2/$GENE_1/g" TEMP.hyb > $OUT_FILE
awk -v GENE_1=$GENE_1 -v GENE_2=$GENE_2 -v X1=$X1 -v X2=$X2 -v Y1=$Y1 -v Y2=$Y2 -v X_COORD=$X_COORD -v Y_COORD=$Y_COORD -v LEN=$LEN '{if ($4~GENE_1 && $7>=X1 && $8<=X2 && $10~GENE_2 && $13>=Y1 && $14<=Y2) print $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$6"\t"$7-X_COORD+1"\t"$8-X_COORD+1"\t"$9"\t"$4"\t"$11"\t"12"\t"$13-Y_COORD+LEN+101"\t"$14-Y_COORD+LEN+101; if ($10~GENE_1 && $13>=X1 && $14<=X2 && $4~GENE_2 && $7>=Y1 && $8<=Y2 && GENE_1!=GENE_2) print $1"\t"$2"\t"$3"\t"$10"\t"$5"\t"$6"\t"$7-Y_COORD+LEN+101"\t"$8-Y_COORD+LEN+101"\t"$9"\t"$10"\t"$11"\t"12"\t"$13-X_COORD+1"\t"$14-X_COORD+1}' $IN_FILE > $OUT_FILE

#extracting fasta sequence
pf.pl $FASTA_1 $X1 $X2 > $OUT_FASTA
#padding
pf.pl $FASTA_1 1 100 >> $OUT_FASTA
#second RNA fragment
pf.pl $FASTA_2 $Y1 $Y2 >> $OUT_FASTA

#merging fasta sequences with padding in between, create space for folding
awk 'NF' $OUT_FASTA | awk 'BEGIN{i=1}{line[i++]=$0}END{print line[1]"\n"line[2] line[4] line[6]}' > tmp && mv tmp $OUT_FASTA

