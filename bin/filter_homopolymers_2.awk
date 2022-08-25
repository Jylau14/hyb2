#!/usr/bin/awk -f

BEGIN{
	LEN=15
}

NR==1{
	for(i=1;i<=LEN;i++){
		A=(A "A")
		C=(C "C")
		G=(G "G")
		T=(T "T")
		a=(a "a")
		c=(c "c")
		g=(g "g")
		t=(t "t")
	}
	regex=(A "|" C "|" G "|" T  "|" a  "|" c  "|" g  "|" t)
}

{if(match($0,regex) || $4!~$10)
	print $0"\t" "."
else
	print $0
}

