#!/usr/bin/perl

# example: blast2gplot.pl EXP=exp1 N_GENES=20 REF_BLAST_FILE=hybrids.blast BLAST_FILE=in.blast GENE_LENGTHS_FILE=human_OH_3_gene_lengths.txt
# craetes output files automatically

$EXP = "exp1";
$N_GENES = 10;
$BLAST_FILE = "input.blast";
$REF_BLAST_FILE = "";
$GENE_LENGTHS_FILE = "human_OH_3_gene_lengths.txt";
%gi = ();
%len = ();
%found_gene = ();

# parsing command line arguments awk-style
eval '$'.$1.'$2;' while $ARGV[0] =~ /^([A-Za-z_0-9]+=)(.*)/ && shift; 

if ( !$REF_BLAST_FILE ){
	$REF_BLAST_FILE = $BLAST_FILE;
}

# putting counts of hits of all genes in hash %gi. hash_adress = gi, hash_value = number_of_hits 
# open BLAST_FILE, "<", "Ago1_A2_compressed_human_OH_3_tophits.mRNA.blast" or die "cannot open file";
open REF_BLAST_FILE, "<", $REF_BLAST_FILE or die "cannot open file $REF_BLAST_FILE";
while( <REF_BLAST_FILE> ){
	chomp;
        @Fld = split ("\t",$_);
	$_ =~ /gi\|([0-9]*)\|/g;	
	if ( $Fld[9] > $Fld[8] ){
#		$gi{ $1 }++; 			old version, looked for gi in gene names, specific to hOH3 database
		$gi{ $Fld[1] }++;		# new version, uses entire gene name as gene id
	}
}
close REF_BLAST_FILE;

# creating array with gi's sorted by number_of_hits
# creating hash with gi's of genes with top number_of_hits
@sorted_gi = sort { $gi{$b} <=> $gi{$a} } keys %gi;
foreach my $i (0 .. $N_GENES-1){
	$top_gi{ $sorted_gi[$i] }++;
}

# putting lengths of all genes in hash %len addressed by gi.
# WARNING: putting the lengths into an _array_ addressed by gi caused huge memory usage because gi's are large numbers 
open GENE_LENGTHS_FILE, "<", $GENE_LENGTHS_FILE or die "cannot open file $GENE_LENGTHS_FILE";
while( <GENE_LENGTHS_FILE> ){
	chomp;
	@Fld = split ("\t",$_);
#	$_ =~ /gi\|([0-9]*)\|/g;		old version, looked for gi in gene names, specific to hOH3 database
#	my $curr_gi = $1;			old version, looked for gi in gene names, specific to hOH3 database
	my $curr_gi = $Fld[ 0 ];		# new version, uses entire gene name as gene id
	$len{$curr_gi} = $Fld[1];
}
close GENE_LENGTHS_FILE;

# reading numbers of hits at each position for the top genes. saving results in hash %data.
open BLAST_FILE, "<", $BLAST_FILE or die "cannot open file $BLAST_FILE";
while( <BLAST_FILE> ){
        chomp;
        @Fld = split ("\t",$_);
#       $_ =~ /gi\|([0-9]*)\|/g;		old version, looked for gi in gene names, specific to hOH3 database
#	my $curr_gi = $1;			old version, looked for gi in gene names, specific to hOH3 database
	my $curr_gi = $Fld[ 1 ];		# new version, uses entire gene name as gene id	
        if ( $top_gi{$curr_gi} && $Fld[9] > $Fld[8] ){
		for ($i = $Fld[8]; $i <= $Fld[9]; $i++) {
			$data{$curr_gi}{$i}++;
		}
	}
}
close BLAST_FILE;

&make_gplot_files;

sub make_gplot_files{
	foreach my $i (0 .. $N_GENES-1){
		$curr_gene = $sorted_gi[$i];
		$curr_filename = sprintf "%s_%s.gplot", $EXP, $curr_gene;
		$curr_gplot_tag = sprintf "#%s_%s_%s\n", $EXP, $curr_gene, $len{ $curr_gene };
		open OUTPUT, ">", $curr_filename;
		print OUTPUT $curr_gplot_tag;;
		foreach my $j (1 .. $len{ $curr_gene }){
			$val = $data{$curr_gene}{$j};
			if ( $val ){
				print OUTPUT "$j\t$val\n";
			}
			else{
				print OUTPUT "$j\t0\n";
			}
		}
		close OUTPUT
	}
}


