#!/usr/bin/env perl
use strict;
use warnings;
use English qw(-no-match-vars);

=pod

PROBLEM STATEMENT:

Given a line of text consisting of ...
Then next line contains ...

The program will...

Output the ...

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
my $something;
my $else;
my $output;

while (my $input = <$in>) {
	chomp($input);
	if ($input =~ m{\A#=(.+)\z})
	{
		next if !$test;
		my $expected = $1;

		my $got = $something;

		if ($got eq $expected) {
			print qq{$got\n};
		} else {
			print qq{NOT OK expected: ($expected) but got ($got)\n};
		}
		# VARS INIT
		$something = undef;
		$else = undef;
		$output = undef;
		next;
	}
	if (!$something) {
		$something = $input;
		my $value = $something;
		die "You should provide an integer value, you gave $value: $input\n" unless $value =~ m{\A[-+]?\d+\z}xms;
		die "You should provide a positive integer value, you gave $value: $input\n" unless $value =~ m{\A\+?[1-9]\d*\z}xms;
		die "You should provide a non-negative integer value, you gave $value: $input\n" unless $value =~ m{\A\+?\d*\z}xms;

	} else {
		$else = $input;
		my $length = length($something);
		my $short = length($else);
		die "You specified a proofread message of $short characters but it should be exactly one less than the original length $length." if ($length != 1 + $short);

		$output = do_something($something, $output);

		if (!$test) {
			print qq{$output\n};
			exit 0;
		}
	}
}

sub do_something {
	my ($first, $second) = @ARG;
	return qq{$first $second};
}

# lines of input to program when --test is run followed by a #= line with desired output
__DATA__
inout line 1
input line 2
#=d

