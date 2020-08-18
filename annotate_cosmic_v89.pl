

my %hash;

my $index=0;

open (DATA, "/rsrch3/home/genomic_med/fwang6/fwang6/database/cosmicv89/hg19_cosmic89.confirmed.txt") || die $!;

while (<DATA>) {
	chomp();
	my @array = split /\t/;
	$hash{$array[0]}{$array[1]}{$index} = $array[5];
	$hash2{$array[0]}{$array[1]}{$array[3]}{$array[4]} = $array[5];
	$index++;
}

close DATA;

open (INPUT, "$ARGV[0]") || die $!;

while (<INPUT>) {
	chomp();
	if ($_ =~ /^type/) {
		print "$_\tCosmic_v89_cluster\tCosmic_v89_cluster_distance\n";
		next;
	}
	print "$_\t";
	my @array = split/\t/;
	my @id;
	my @dis;
	if (exists $hash2{$array[1]}{$array[2]}{$array[4]}{$array[5]}) {
		print "$hash2{$array[1]}{$array[2]}{$array[4]}{$array[5]}\tMatch\n";

		next;
	}

	my $judge =0;
	for (my $i=$array[2]-11; $i<=$array[2]+11; $i++) {
		if (exists $hash{$array[1]}{$i}) {
			my @id_array;
			my @times_array;
			my $id_final;
			foreach my $in (keys %{$hash{$array[1]}{$i}}) {
				my $id_tmp = $hash{$array[1]}{$i}{$in};
				my @cosmic = split (/\;/, $id_tmp);
				my @cosmic_ids = split (/[,=]/, $cosmic[0]);
				shift @cosmic_ids;
				my @times = split (/[,=]/, $cosmic[1]);
				shift @times;
				push (@id_array, @cosmic_ids);
				push (@times_array, @times);
				
			}
			
			my $id_final1 = join (",", @id_array);
			my $id_final2 = join (",",@times_array);
			$id_final = "ID=".$id_final1.";OCCURENCE=".$id_final2;

			if ($i eq $array[2]) {
				print "$id_final\tSame_Position\n";
				
				$judge = 1;
			}
			push (@id, $id_final);	
			push (@dis, $i-$array[2]);
		}


	}

	if ($judge eq 0) {
	print join ("||", @id);
	print "\t";
	print join ("||", @dis);
	print "\n";
	}
}

close INPUT;
