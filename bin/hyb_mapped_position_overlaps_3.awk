#!/usr/bin/awk -f

BEGIN{ OFS="\t" }

$4==$10 && $16!="."{
	ovlp=overlap( $7, $8, $13, $14)
	print $0 "\t" ovlp
}

$16=="."{
	print $0
}

function min(a, b){
	if(a<b){return a}
	return b
}

function max(a, b){
	if(a>b){return a}
	return b
}

function overlap(a, b, c, d){
        return 1 + min( b, d ) - max( a, c )
}

