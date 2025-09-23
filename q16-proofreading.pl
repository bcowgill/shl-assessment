#!/usr/bin/env perl
use strict;
use warnings;
use English qw(-no-match-vars);

=pod

PROBLEM STATEMENT:

Given a line of text consisting of the original manuscript.
Then next line contains the proofread version of the manuscript with a single missing character.

Output the single character that the proofread manuscript is missing.

=cut

my $in = *STDIN;
my $test;
my $arg = $ARGV[0] || '';
if ($arg eq '--test') {
	$test = 1;
	$in = *DATA;
}
my $debug = 0;#$test;

my $original;
my $proofread;
my $missing;

while (my $input = <$in>) {
	chomp($input);
	if ($input =~ m{\A#=(.+)\z})
	{
		next if !$test;
		my $expected = $1;

		my $got = $missing;

		if ($got eq $expected) {
			print qq{$got\n};
		} else {
			print qq{NOT OK expected: ($expected) but got ($got)\n};
		}
		$original = undef;
		$proofread = undef;
		$missing = undef;
		next;
	}
	if (!$original) {
		$original = $input;
	} elsif (!$proofread) {
		$proofread = $input;
		my $length = length($original);
		my $short = length($proofread);
		die "You specified a proofread message of $short characters but it should be exactly one less than the original length $length." if ($length != 1 + $short);

		$missing = get_missing($original, $proofread);

		if (!$test) {
			print qq{$missing\n};
			exit 0;
		}
	}
}

sub get_missing {
	my ($original, $proofread) = @ARG;
	my $missing;
	my $length = length($original);

	for (my $idx = 0; $idx < $length; ++$idx) {
		my $o = substr($original, $idx, 1);
		my $p = substr($proofread, $idx, 1);
		if ($o ne $p) {
			$missing = $o;
			last;
		}
	}
	return $missing;
}

__DATA__
the quick brown fox jumped over the lazy dog
the quick brown fox jumpe over the lazy dog
#=d
the quick brown fox jumped over the lazy dog
the quick brown fox jumped over the lazy do
#=g
the quick brown fox jumped over the lazy dog
he quick brown fox jumped over the lazy dog
#=t

