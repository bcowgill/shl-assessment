#!/usr/bin/env perl
use strict;
use warnings;
use integer;
use English qw(-no-match-vars);

=pod

PROBLEM STATEMENT:

Given a single line string of characters from the alphabet representing the cottage labels.

Output only the non-vowel cottages. or nothing at all.

=cut

my $in = *STDIN;
my $test;
my $arg = $ARGV[0] || '';
if ($arg eq '--test') {
	$test = 1;
	$in = *DATA;
}
my $debug = 0;#$test;

my $cottages;
my $do_not_renovate;

while (my $input = <$in>) {
	chomp($input);
	if ($input =~ m{\A#=(.+)\z})
	{
		next if !$test;
		my $expected = $1;
		my $got = $do_not_renovate;
		if ($got eq $expected) {
			print qq{$got\n};
		} else {
			print qq{NOT OK expected $expected but got $got\n};
		}
		$cottages = undef;
		$do_not_renovate = undef;
		next;
	}
	if (!$cottages) {
		$input =~ s{\s+}{}xmsg;
		print qq{i: [$input]\n} if $debug;
		$cottages = $input;
		print qq{c: [$cottages]\n} if $debug;
		$input =~ s{[a-z]+}{}xmsgi;
		print qq{i2: [$input]\n} if $debug;
		die "You must provide only letters of the alphabet, you gave: $input" unless $cottages =~ m{\A[a-z]+\z}xmsi;
		
		$do_not_renovate = get_non_vowels($cottages);

		if (!$test) {
			print qq{$do_not_renovate\n} if $do_not_renovate;
			exit 0;
		}
	}
}

sub get_non_vowels
{
	my ($string) = @ARG;
	$string =~ s{[aeiou]}{}xmsgi;
	return $string;
}

__DATA__
Mynameisanthony
#=Mynmsnthny
agh dkeucmdychdkvkuyl dflknkvckjsoureASVCNVALIEIUOHVALSDKFSHIUG
#=ghdkcmdychdkvkyldflknkvckjsrSVCNVLHVLSDKFSHG
