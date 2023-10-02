#!/usr/bin/perl
# use: perl pf.pl filename.fasta start end
# writes to standard output fragments (from start to end) of all sequences in filename.fasta

use Bio::SeqIO;

# set input file and nucl start and end numbers

        my $my_file="in.txt";
        my $start=0;
        my $end=100;

        if ($ARGV[0]) {$my_file=$ARGV[0]}
        if ($ARGV[1]) {$start=$ARGV[1]}
        if ($ARGV[2]) {$end=$ARGV[2]}

#create an object for fasta file input/output

        $seqio_obj = Bio::SeqIO->new(-file => $my_file,-format => "fasta", -alphabet => 'dna');

#output substrings

        while ($seq_obj = $seqio_obj->next_seq){        # this is a Bioperl Seq object, which comprises the sequence itself, and its descriptions (if any)

                $my_name = $seq_obj->display_id;                # get sequence name
                $my_seq = $seq_obj->seq;                                # get a string with the sequence itself
                $my_fragment = substr($my_seq, $start-1, 1+$end-$start);        # get an appropriate substring
                print ">$my_name\n$my_fragment\n";

        }

        print "\n";

