#!/usr/bin/env perl
use strict;
use warnings;
use integer;
use English qw(-no-match-vars);

=pod

PROBLEM STATEMENT:

Given a single line of text from the input.

Output a the string of text with all vowels removed.

=cut

my $in = *STDIN;
my $test;
my $arg = $ARGV[0] || '';
if ($arg eq '--test') {
	$test = 1;
	$in = *DATA;
}
my $debug = 0;#$test;

my $prose;
my $output;

while (my $input = <$in>) {
	chomp($input);
	if ($input =~ m{\A#=(.+)\z})
	{
		next if !$test;
		my $expected = $1;
		my $got = $output;
		if ($got eq $expected) {
			print qq{$got\n};
		} else {
			print qq{NOT OK expected $expected but got $got\n};
		}
		$prose = undef;
		$output = undef;
		next;
	}
	if (!$prose) {
		$prose = $input;
		
		$output = strip_out_vowels($prose);

		if (!$test) {
			print qq{$output\n} if $output;
			exit 0;
		}
	}
}

sub strip_out_vowels
{
	my ($string) = @ARG;
	$string =~ s{[aeiou]}{}xmsgi;
	return $string;
}

__DATA__
Mynameisanthony
#=Mynmsnthny
agh dkeucmdychdkvkuyl dflknkvckjsoureASVCNVALIEIUOHVALSDKFSHIUG
#=gh dkcmdychdkvkyl dflknkvckjsrSVCNVLHVLSDKFSHG
this is A LINE of text that should have VOWELS removed FROM it
#=ths s  LN f txt tht shld hv VWLS rmvd FRM t
