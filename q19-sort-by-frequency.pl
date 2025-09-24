#!/usr/bin/env perl
use strict;
use warnings;
use English qw(-no-match-vars);
use Data::Dumper;

=pod

PROBLEM STATEMENT:

Given a line of text consisting of a positive integer numofvalues(N), representing the number of numbers to expect on the next line.
Then next line contains N space separated positive integers representing each number of the N length sequence.

We want to output each unique number value seen in descending order by the number of times it appears in the sequence.  i.e. sort by histogram.  If two numbers have the same frequency then they should appear in the output in the same order they were in the input.

=cut

my $in = *STDIN;
my $test;
my $arg = $ARGV[0] || '';
if ($arg eq '--test') {
	$test = 1;
	$in = *DATA;
}
my $debug = $test; # or 0 for no debugging

# VARS INIT
my $num_of_values;
my @Sequence = ();
my %Histogram = ();
my %Index = ();
my @Unique = ();
my @Ordered = ();
my $output;

while (my $input = <$in>) {
	chomp($input);
	if ($input =~ m{\A#=(.+)\z})
	{
		next if !$test;
		my $expected = $1;
		my $got = join(" ", @Ordered);

		if ($got eq $expected) {
			print qq{$got\n};
		} else {
			print qq{NOT OK expected: ($expected) but got ($got)\n};
		}
		# VARS INIT
		$num_of_values = undef;
		@Sequence = ();
		%Histogram = ();
		%Index = ();
		@Unique = ();
		@Ordered = ();
		$output = undef;
		next;
	}
	if (!$num_of_values) {
		my $value = $input;
		die "You should provide a positive integer value, you gave $value: $input\n" unless $value =~ m{\A\+?[1-9]\d*\z}xms;
		$num_of_values = int($value);
	} elsif (!scalar(@Sequence)) {
		@Sequence = split(/\s+/, $input);
		my $count = scalar(@Sequence);
		die "You should provide exactly $num_of_values space separated positive integers, you gave $count: $input\n" unless $count == $num_of_values;
		foreach my $value (@Sequence) {
			die "You should provide a positive integer value, you gave $value: $input\n" unless $value =~ m{\A\+?[1-9]\d*\z}xms;
		}

		@Ordered = get_ordered(\@Sequence);
		$output = join(" ", @Ordered);

		if (!$test) {
			print qq{$output\n};
			exit 0;
		}
	}
}

sub by_frequency {
	return $Histogram{$b} <=> $Histogram{$a} || $Index{$a} <=> $Index{$b};
}

sub get_ordered {
	my ($raSequence) = @ARG;
	my $num = scalar(@$raSequence);
	for (my $idx = 0; $idx < $num; ++$idx) {
		my $value = int($raSequence->[$idx]);
		$Index{$value} = $idx unless $Histogram{$value};
		$Histogram{$value}++;
	}
	@Unique = keys(%Histogram);
	return sort by_frequency @Unique;
}

sub is_perfect_square {
	my ($bill) = @ARG;
	my $root = sqrt($bill);
	return $root == int($root);
}

# lines of input to program when --test is run followed by a #= line with desired output
__DATA__
+2
4 +7
#=4 7
+2
+7 4
#=7 4
+3
4 +7 +7
#=7 4
6
25 77 54 81 48 34
#=25 77 54 81 48 34
4
99 56 12 44
#=99 56 12 44
33
1 4 5 2 4 3 2 4 5 2 4 6 78 3 4 2 3 3 1 3 7 9 20 2 4 7 10 3 8 5 2 4 78
#=4 2 3 5 1 78 7 6 9 20 10 8