#!/usr/bin/awk -f

# new in plot_hybrids_3.awk: now correctly outputs numbers of hybrids with USE_ENTIRE_HYBRIDS=1 and BIN_SIZE>1 
# this inputs .txt or .hyb file with hybrids (one line per hybrid) and generates files with positions of hybrids

BEGIN{ 
	OFS="\t" 
	GENE_1 = "rDNA"
	GENE_2 = "rDNA"
	THRESHOLD_NUM = 0
	BIN_SIZE = 1
	USE_ENTIRE_HYBRIDS = 0	
}

!USE_ENTIRE_HYBRIDS{
	a = BIN_SIZE * int($8/BIN_SIZE)
	b = BIN_SIZE * int($13/BIN_SIZE)
	if ($4==GENE_1 && $10==GENE_2) { c[a "\t" b]++ }
	if ($4==GENE_2 && $10==GENE_1 && GENE_1!=GENE_2) { d[a "\t" b]++ }
}

USE_ENTIRE_HYBRIDS{
	a = BIN_SIZE * int($7/BIN_SIZE)
	b = BIN_SIZE * int($8/BIN_SIZE)
	e = BIN_SIZE * int($13/BIN_SIZE)
	f = BIN_SIZE * int($14/BIN_SIZE)
	if ($4==GENE_1 && $10==GENE_2) { 
		for(i=a; i<=b; i+=BIN_SIZE){
			for(j=e; j<=f; j+=BIN_SIZE){
				c[i "\t" j]++
			}
		}
	}
	if ($4==GENE_2 && $10==GENE_1 && GENE_1!=GENE_2){
		for(i=a; i<=b; i+=BIN_SIZE){
			for(j=e; j<=f; j+=BIN_SIZE){
				d[i "\t" j]++
			}
		}
	}
}

END{

	print ("# hybrids between " GENE_1 " and " GENE_2);
	for (i in c){ 
		if( c[i] > THRESHOLD_NUM ) {print i, c[i]} 
	}
	
	if( GENE_1 != GENE_2 ){
		print ("# hybrids between " GENE_2 " and " GENE_1)
		for (i in d){ 
			if( d[i] > THRESHOLD_NUM ) {print i, d[i]}
		}
	}
}
