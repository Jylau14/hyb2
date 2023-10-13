#!/bin/bash
#modify coords of svg file from VARNA RNA Structure

#parsing command line options
while getopts "i:x:y:l:" OPTION
do
        case $OPTION in
                i) IN_FILE=$OPTARG ;;
                x) X_COORD=$OPTARG ;;
                y) Y_COORD=$OPTARG ;;
                l) LEN=$OPTARG ;;
                ?)

                echo "incorrect option"
                exit 0
                ;;
        esac
done

OUT_FILE=${IN_FILE/.svg/_plot.svg}
X=$(($X_COORD-1))

if [ -z $Y_COORD ]
then
        awk -v X=$X '{split($10,a,"<"); split(a[1],b,">"); if ($10~/text/ && $10!~/>[A-Z]</ && $6~/7.5/) print $0" >"b[2]+X"</text>"; else print $0}' $IN_FILE | awk '{if ($10~/text/ && $10!~/>[A-Z]</ && $6~/7.5/) $10=" "; print $0}' > $OUT_FILE
	sed -i 's/stroke-width="1.0"/stroke-width="0.25"/g' $OUT_FILE
elif [ -z $X_COORD ] && [ -z $Y_COORD ]
then
        sed 's/stroke-width="1.0"/stroke-width="0.25"/g' $IN_FILE > $OUT_FILE
else
        Y=$(($Y_COORD-1))
        awk -v X=$X -v Y=$Y -v L=$LEN '{split($10,a,"<"); split(a[1],b,">"); if ($10~/text/ && $10!~/>[A-Z]</ && $6~/7.5/ && b[2]<=L) print $0" >"b[2]+X"</text>"; else if ($10~/text/ && $10!~/>[A-Z]</ && $6~/7.5/ && b[2]>L && b[2]<=L+100) print $0" "$10; else if ($10~/text/ && $10!~/>[A-Z]</ && $6~/7.5/ && b[2]>L+100) print $0" >"b[2]+Y-L-100"</text>"; else print $0}' $IN_FILE | awk '{if ($10~/text/ && $10!~/>[A-Z]</ && $6~/7.5/) $10=" "; print $0}' > $OUT_FILE
        sed -i 's/stroke-width="1.0"/stroke-width="0.25"/g' $OUT_FILE
fi

