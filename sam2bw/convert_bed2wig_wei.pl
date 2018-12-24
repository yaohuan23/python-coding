#!/usr/bin/perl
# convert_bed_to_wig.pl
# Convert bed files to wig files
# I modified from Lee's script -- Wei

# INPUT FILE:  Processed BED files generated from ELAND output
#	format:  9 colums
#		col 1: chromosome
#		col 2: starting position
#		col 3: ending position
#		col 4: label
#		col 5: score
#		col 6: direction
#		col 7: thick start
#		col 8: thick end
#		col 9: color
# chr9    123691875       123692174       Neg1    1       -       123691875       123692174       153,255,153

# If heading line is included it will be ignored

# Chromsome array sizes are 1 more than chromosome size to mimic a base-1 array
# Array sizes are from hg18 of the UCSC genome browser

# Each base is considered 1 data point

# Minimum score for including data point is an input parameter

# Ignore score from BED file

use strict;
#use warnings;

my $inputfile;
my $outputfile;
my $line;
my @line_array;
my $start;
my $end;
my $chromosome;
my $minimum_score;

my $lcv;
my $lcv_end;

my @chr_score;
my $chromosome_length;

my @chr_length_all;
my @chr_all;
my $chr_index;
my $name;
my $input;

unless (scalar @ARGV == 3)
{
        print STDERR "Usage: $0: \t parameter 1: BED file (heading line will be ignored if included)\tparameter 2: minimum score 3: genome\n";
        exit(0);
}
if ($ARGV[2] eq "hg19"){
	@chr_all = ("chr1","chr2","chr3","chr4","chr5","chr6","chr7","chr8","chr9","chr10","chr11","chr12","chr13","chr14","chr15","chr16","chr17","chr18","chr19","chr20","chr21","chr22","chrX","chrY");
#	@chr_length_all = (247249720,242951150,199501828,191273064,180857867,170899993,158821425,146274827,140273253,135374738,134452385,132349535,114142981,106368586,100338916,88827255,78774743,76117154,63811652,62435965,46944324,49691433,154913755,57772955);
	@chr_length_all = (249250621,243199373,198022430,191154276,180915260,171115067,159138663,146364022,141213431,135534747,135006516,133851895,115169878,107349540,102531392,90354753,81195210,78077248,59128983,63025520,48129895,51304566,155270560,59373566);
}
elsif ($ARGV[2] eq "mm9"){
	@chr_all = ("chr1","chr2","chr3","chr4","chr5","chr6","chr7","chr8","chr9","chr10","chr11","chr12","chr13","chr14","chr15","chr16","chr17","chr18","chr19","chrX","chrY");
	@chr_length_all = (197195432,181748087,159599783,155630120,152537259,149517037,152524553,131738871,124076172,129993255,121843856,121257530,120284312,125194864,103494974,98319150,95272651,90772031,61342430,166650296,15902555);
}
else{
	print STDERR "Usage: $0: \tno chr len infor in convert_bed2wig_wei.pl\n";
	exit(0);		
}

$inputfile = $ARGV[0];
$minimum_score = $ARGV[1];
$inputfile =~ /((.*).long.bed)/;
$name=$2;
print "$name";


$outputfile = "$inputfile.min$minimum_score.wig";

open (OUTFILE, ">$outputfile") or die "couldn't open output file $outputfile\n";

print OUTFILE "track type = wiggle_0\n";

for ($chr_index = 0; $chr_index <= $#chr_all; $chr_index++)

{ 
	$input = "$name.$chr_all[$chr_index].txt";
	open (INFILE, "<$input") or die "couldn't open input file $input\n";
	
	$chromosome_length = $chr_length_all[$chr_index];
	
	my $real_chr_index = $chr_index+1;	
#	print STDOUT "Processing chromosome $real_chr_index\n";

#	print STDOUT "\tInitializing array\n";
	for ($lcv = 0; $lcv <= $chromosome_length; $lcv++)
	{
		$chr_score[$lcv] = 0;
	}
#	print STDOUT "\tReading BED file\n";

	while ($line = <INFILE>)
	{

		if ($line =~ /track/)
		{
			next;
		}

		chomp($line);
		@line_array = split(/\t/,$line);
		$chromosome = $line_array[0];
		$start = $line_array[1];
		$end = $line_array[2];

		for ($lcv = $start; $lcv <= $end; $lcv++)
		{
			$chr_score[$lcv]++;
		}
	}

#	print STDOUT "\tGenerating wig file entries\n";

	$lcv = 1;

	while ($lcv < $chromosome_length)
	{
		if ($chr_score[$lcv] < $minimum_score)
		{
			$lcv++;
			next;
		}

		$lcv_end = $lcv + 1;

		while ( ($chr_score[$lcv_end] == $chr_score[$lcv]) && ($lcv_end <= $chromosome_length) )
		{
			$lcv_end++;
		}

		print OUTFILE "$chr_all[$chr_index]\t$lcv\t$lcv_end\t$chr_score[$lcv]\n";

		$lcv = $lcv_end + 1;
	}

	#-----------------------------------------------
	# Reset
	#-----------------------------------------------
	@chr_score = ();
	close INFILE;
}

close OUTFILE;

#print STDOUT "\nConversion complete. Output is located in $outputfile\n";
