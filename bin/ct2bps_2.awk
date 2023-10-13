#!/usr/bin/awk -f

BEGIN{OFS="\t"}
/dG/{
	n=split($8,a,"-")
	x=split(a[n/2],i,"_")
	y=split(a[n],j,"_")
	bit1_st=i[x-1]
	bit1_en=i[x]
	bit2_st=j[y-1]
	bit2_en=j[y]
	bit1_len=bit1_en-bit1_st+1
}

!/dG/ && $5{
	if($1<=bit1_len){
		st=bit1_st+$1-1
		en=bit2_st+$5-bit1_len-1
		print st, en
	}
}
