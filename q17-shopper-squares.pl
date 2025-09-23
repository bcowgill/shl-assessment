#!/usr/bin/env perl
use strict;
use warnings;
use English qw(-no-match-vars);
use Data::Dumper;

=pod

PROBLEM STATEMENT:

Given a line of text consisting of a positive integer numofcust (N), representing the number of customers with bills.
Then next line contains N space separated positive integers representing the total bill for each customer (shopper.)

The store is going to award a promotional gift of a future discount to any customer whose bill is a perfect square.

Output the number of customers whose bill value is a perfect square.

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
my $num_of_cust;
my @Customers = ();
my @Squares = ();
my $output;

while (my $input = <$in>) {
	chomp($input);
	if ($input =~ m{\A#=(.+)\z})
	{
		next if !$test;
		my $expected = $1;
		my $got = scalar(@Squares);

		if ($got eq $expected) {
			print qq{$got\n};
		} else {
			print qq{NOT OK expected: ($expected) but got ($got)\n};
		}
		# VARS INIT
		$num_of_cust = undef;
		@Customers = ();
		@Squares = ();
		$output = undef;
		next;
	}
	if (!$num_of_cust) {
		my $value = $input;
		die "You should provide a positive integer value, you gave $value: $input\n" unless $value =~ m{\A\+?[1-9]\d*\z}xms;
		$num_of_cust = int($value);
	} elsif (!scalar(@Customers)) {
		@Customers = split(/\s+/, $input);
		my $count = scalar(@Customers);
		die "You should provide exactly $num_of_cust space separated positive integers, you gave $count: $input\n" unless $count == $num_of_cust;
		foreach my $value (@Customers) {
			die "You should provide a positive integer customer bill value, you gave $value: $input\n" unless $value =~ m{\A\+?[1-9]\d*\z}xms;
		}

		@Squares = get_squares(\@Customers);
		$output = scalar(@Squares);

		if (!$test) {
			print qq{$output\n};
			exit 0;
		}
	}
}

sub get_squares {
	my ($raCustomers) = @ARG;
	return grep { is_perfect_square($ARG) } map { int($ARG) } @$raCustomers;
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
#=1
6
25 77 54 81 48 34
#=2
4
99 56 12 44
#=0