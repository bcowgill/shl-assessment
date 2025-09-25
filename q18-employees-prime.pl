#!/usr/bin/env perl
use strict;
use warnings;
use English qw(-no-match-vars);
use Data::Dumper;

=pod

PROBLEM STATEMENT:

Given a line of text consisting of a positive integer numofemp (N), representing the number of employees with evaluation scores.
Then next line contains N space separated integers representing the evaluation score for each employee.

The company wants to identify which employees have scores that are prime numbers.

Output the number of employees whose evaluation score is a prime number.

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
my $num_of_emp;
my @Employees = ();
my @Primes = ();
my $output;

# cache all known primes so we don't recompute again
# largest 64 bit prime
#18446744073709551557
my %Prime = map { ($ARG, 1) } qw(18446744073709551557);
#print Dumper(\%Prime);

while (my $input = <$in>) {
	chomp($input);
	if ($input =~ m{\A#=(.+)\z})
	{
		next if !$test;
		my $expected = $1;
		my $got = scalar(@Primes);

		if ($got eq $expected) {
			print qq{$got\n};
		} else {
			print qq{NOT OK expected: ($expected) but got ($got)\n};
		}
		# VARS INIT
		$num_of_emp = undef;
		@Employees = ();
		@Primes = ();
		$output = undef;
		next;
	}
	if (!$num_of_emp) {
		my $value = $input;
		die "You should provide a positive integer value, you gave $value: $input\n" unless $value =~ m{\A\+?[1-9]\d*\z}xms;
		$num_of_emp = int($value);
	} elsif (!scalar(@Employees)) {
		@Employees = split(/\s+/, $input);
		my $count = scalar(@Employees);
		die "You should provide exactly $num_of_emp space separated integers, you gave $count: $input\n" unless $count == $num_of_emp;
		foreach my $value (@Employees) {
			die "You should provide an integer employee evaluation score value, you gave $value: $input\n" unless $value =~ m{\A[-+]?\d*\z}xms;
		}

		@Primes = get_primes(\@Employees);
		$output = scalar(@Primes);

		if (!$test) {
			print qq{$output\n};
			exit 0;
		}
	}
}

sub get_primes {
	my ($raEmployees) = @ARG;
	return grep { is_prime($ARG) } map { int($ARG) } @$raEmployees;
}

sub is_prime {
	my ($score) = @ARG;

	return 1 if $Prime{$score} || $score == 2;
	return 0 if $score <= 1;
	# handle anything divisible by two first
	return 0 if $score % 2 == 0;
	for (my $factor = 3; $factor <= sqrt($score); $factor += 2) {
		return 0 if $score % $factor == 0;
	}
	$Prime{$score} = 1;
	return 1;
}

# lines of input to program when --test is run followed by a #= line with desired output
__DATA__
+2
4 +7
#=1
6
25 77 54 81 48 34
#=0
4
99 56 12 44
#=0
16
0 1 2 3 4 5 6 7 29 557 2147483647 2147483646 2147483646 2147483647 18446744073709551557 18446744073709551556
#=9
1
0
#=0
1
1
#=0
1
2
#=1
1
-1
#=0
1
3
#=1