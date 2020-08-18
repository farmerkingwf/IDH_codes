

system("cat $ARGV[0] | grep -v type |cut -f 2,3,5,6 | sort | uniq > $ARGV[0].dbnsfp.in");

system("/usr/bin/java  -classpath /rsrch3/home/genomic_med/fwang6/fwang6/database  search_dbNSFP30b2a -v hg19 -w 8-9,3-4,24-26,30-38,40-42,47-55,58-78 -i $ARGV[0].dbnsfp.in -o $ARGV[0].dbnsfp.out");


my %hash;

open (DATA, "$ARGV[0].dbnsfp.out") || die $!;

while (<DATA>) {
	chomp();
	my @array = split /\t/;
	$hash{$array[0]}{$array[1]}{$array[2]}{$array[3]} = \@array;
#	print $_;
}

close DATA;


open (OUTPUT, ">$ARGV[1]") || die $!;

open (INPUT, "$ARGV[0]") || die $!;



my $length;
while (<INPUT>) {
	chomp();
	

	if ($_ =~ /^type/) {
		print OUTPUT "$_";
		my $header_ref = $hash{"hg19_chr"}{"hg19_pos(1-based)"}{"ref"}{"alt"};
		my @header = @$header_ref;
		my $header_length = @header;
		$length =$header_length;
		for (my $i=4; $i<$header_length; $i++) {
			print OUTPUT  "\t$header[$i]";

		}

		print OUTPUT "\n";
		next;
	}
	

	my @array2 = split/\t/;
#	print "$array2[2]\n";
#	print "$_";	

	if (exists $hash{$array2[1]}{$array2[2]}{$array2[4]}{$array2[5]}) {
		print OUTPUT "$_";
		my $line_ref = $hash{$array2[1]}{$array2[2]}{$array2[4]}{$array2[5]};
                my @line = @$line_ref;
                my $line_length = @line;
                for (my $i=4; $i<49; $i++) {
                        print OUTPUT "\t$line[$i]";

                }
		print OUTPUT "\n";


	} else {
#		print $length;
		print OUTPUT "$_";
		for (my $i=4; $i<49; $i++) {
                        print OUTPUT "\tNA";

                }
                print OUTPUT "\n";
		

	}

}

close INPUT;
#print "$length\n";
close OUTPUT;
