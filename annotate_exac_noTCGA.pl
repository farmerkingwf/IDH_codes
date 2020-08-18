

my %hash;
my %hash2;

open (DATA, "/rsrch3/home/genomic_med/fwang6/fwang6/database/ExAC_nonTCGA.r0.3.1.sites.vep.format.vcf") || die $!;

while (<DATA>) {
	chomp();
	my @array = split /\t/;
	if (($array[6] eq "PASS" ) or ($array[6] =~ /INDEL/)) {
		
	} else {
		next;
	}


	$hash{$array[0]}{$array[1]}{$array[3]}{$array[4]} = $array[7];
	$hash2{$array[0]}{$array[1]}{$array[3]}{$array[4]} = $array[18];


}

close DATA;


open (INPUT, $ARGV[0]) || die $!;

while (<INPUT>) {
	chomp();
	if ($_ =~ /^type/) {
		print "$_\tExAC_f\tExAC_allele_counts\n";
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
