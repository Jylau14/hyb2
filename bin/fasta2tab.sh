#!/bin/bash
awk '{if(NR==1) {print $0} else {if($0 ~ /^>/) {print "\n"$0} else {printf $0}}}' $1 | sed 'N;s/\n/\t/'

