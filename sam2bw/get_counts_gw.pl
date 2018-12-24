#!/usr/bin/perl


MAIN : {
    my ($file, $size, $boundary_file) = @ARGV;
    if ((not defined $file) ||
	(not defined $size) ||
	(not defined $boundary_file)) {
	die ("Usage: ./get_counts.pl <file> <size> <boundary file>\n");
    }

    my $bound;
    open(FILE, $boundary_file) || die ("could not open file ($boundary_file)\n");
    while (my $line = <FILE>) {
	chomp $line;
	my ($chr, $start, $stop) = split(/\t/, $line);
	$bound->{$chr}->{start} = $start;
	$bound->{$chr}->{stop} = $stop;
    }
    close(FILE) || die ("could not close file ($boundary_file)\n");

    my $prev_chr = undef;
    my $prev_bin = 0;
    my $prev_bin_count = 0;
    open(FILE, $file) || die ("could not open file ($file)\n"); #actual reads
    while (my $line = <FILE>) {
	chomp $line;
#change here I can just use the short reads here. 
	my ($chr, $left, $right) = split(/\t/, $line);
#	my $loc = int(($left + $right) / 2);
	my $loc = $left;

	my $bin = int(($loc - $bound->{$chr}->{start}) / $size);

	if (defined $prev_chr) {

	    # print previous, fill in rest to end of chromosome, and fill in all bins up to current
	    if ($chr ne $prev_chr) {  ### Here I skipped the last bin since it always gives out-of-boundary errors
		#print(join("\t",
		#	   $prev_chr,
		#	   $bound->{$prev_chr}->{start} + $prev_bin * $size,
		#	   $bound->{$prev_chr}->{start} + ($prev_bin + 1) * $size,
		#	   $prev_bin_count) . "\n");

		$prev_bin_count = 0;

	    # print previous and fill until current
	    } elsif ($bin != $prev_bin) {
		print(join("\t",
			   $chr,
			   $bound->{$chr}->{start} + $prev_bin * $size,
			   $bound->{$chr}->{start} + ($prev_bin + 1) * $size,
			   $prev_bin_count) . "\n");
		$prev_bin_count = 0;
#
#		for(my $i= $prev_bin + 1 ; $i < $bin ; $i++) {
#		    print(join("\t",
#			       $chr,
#			       $bound->{$chr}->{start} + $i * $size,
#			       $bound->{$chr}->{start} + ($i + 1) * $size,
#			       0) . "\n");
#		}
	    }

	} else {
#	    for(my $i= 0 ; $i < $bin ; $i++) {
#		print(join("\t",
#			   $chr,
#			   $bound->{$chr}->{start} + $i * $size,
#			   $bound->{$chr}->{start} + ($i + 1) * $size,
#			   0) . "\n");
#	    }
	}

	$prev_chr = $chr;
	$prev_bin = $bin;
	$prev_bin_count++;
    }
    close(FILE) || die ("could not close file ($file)\n");

    print(join("\t",
	       $prev_chr,
	       $bound->{$prev_chr}->{start} + $prev_bin * $size,
	       $bound->{$prev_chr}->{start} + ($prev_bin + 1) * $size,
	       $prev_bin_count) . "\n");

#    my $total_bins = int(($bound->{$prev_chr}->{stop} -
#			  $bound->{$prev_chr}->{start}) / $size) + 1;
#
#    for(my $i= $prev_bin + 1 ; $i < $total_bins ; $i++) {
#	print(join("\t",
#		   $prev_chr,
#		   $bound->{$prev_chr}->{start} + $i * $size,
#		   $bound->{$prev_chr}->{start} + ($i + 1) * $size,
#		   0) . "\n");
#    }
}
