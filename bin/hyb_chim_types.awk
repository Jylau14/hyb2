#!/usr/bin/awk -f

BEGIN{ OFS="\t" }

{if($4==$10 && $7<$13 && $8<$13)
	print $0"\t" "Type_1"
else if($4==$10 && $7>$14 && $8>$14)
	print $0"\t" "Type_2"
else if($4==$10 && $7<$13 && $8>$13 && $8<$14)
	print $0"\t" "Type_3"
else if($4==$10 && $7<$13 && $8==$14)
	print $0"\t" "Type_4"
else if($4==$10 && $7<$13 && $8>$14)
	print $0"\t" "Type_5"
else if($4==$10 && $7==$13 && $8>$14)
	print $0"\t" "Type_6"
else if($4==$10 && $7<$14 && $8>$14)
	print $0"\t" "Type_7"
else if($4==$10 && $7==$13 && $8==$14)
	print $0"\t" "Type_8"
else if($4==$10 && $7>$13 && $8==$14)
	print $0"\t" "Type_9"
else if($4==$10 && $7==$13 && $8<$14)
	print $0"\t" "Type_10"
else if($4==$10 && $7>$13 && $8<$14)
	print $0"\t" "Type_11"
else if($4==$10 && $7<$13 && $8==$13)
        print $0"\t" "Type_12"
else if($4==$10 && $7==$14 && $8>$14)
        print $0"\t" "Type_13"
else if($4!=$10)
	print $0"\t" "."
}

