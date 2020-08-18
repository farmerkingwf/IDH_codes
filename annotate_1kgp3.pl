

my %hash;
my %hash2;

open (DATA, "/rsrch3/home/genomic_med/fwang6/fwang6/database/ALL.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.format.vcf") || die $!;

while (<DATA>) {
	chomp();
	my @array = split /\t/;
	next unless $array[6] eq "PASS";
	$hash{$array[0]}{$array[1]}{$array[3]}{$array[4]} = $array[7];
	$hash2{$array[0]}{$array[1]}{$array[3]}{$array[4]} = $array[14];


}

close DATA;


open (INPUT, $ARGV[0]) || die $!;

while (<INPUT>) {
	chomp();
	if ($_ =~ /^type/) {
		print "$_\t1KGp3_f\t1KGp3_allele_counts\n";
		next;
	}
	print "$_\t";
	my @array = split /\t/;
	if (exists $hash{$array[1]}{$array[2]}{$array[4]}{$array[5]}) {
		print "$hash{$array[1]}{$array[2]}{$array[4]}{$array[5]}\t$hash2{$array[1]}{$array[2]}{$array[4]}{$array[5]}\n";

	} else {
		print "NA\tNA\n";
	}

}

close INPUT;
