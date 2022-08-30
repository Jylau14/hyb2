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

match($0,regex){
	next
}

{
	print $0
}

