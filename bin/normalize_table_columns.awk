#!/usr/bin/awk -f

BEGIN{
	FS="\t"
	OFS="\t"
}

NR==FNR{
	cnt[$1]=$2
}

NR!=FNR && (FNR==1 || /^#TABLE/){
	for(i=2;i<=NF;i++){
		if(cnt[$i]){
			norm_factor[i]=cnt[$i]
		}
		else{
			norm_factor[i]=1
			print "normalization factor not found for " $i > "/dev/stderr"
		}
	}
	print $0
}

NR!=FNR && FNR>1 && !/^#/{
	printf $1
        for(i=2;i<=NF;i++){
		printf ("\t" $i/norm_factor[i])
	}
	printf "\n"
}


