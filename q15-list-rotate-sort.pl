#!/usr/bin/env perl
use strict;
use warnings;
use English qw(-no-match-vars);
use Data::Dumper;

=pod

PROBLEM STATEMENT:

Given a line of text containing the number(N) of items in a list.
The next line contains space separated numbers representing the items in the lists.
The last line contains the number(K) of initial items in the list to rotate.

Rotate the initial K items of the list to the right one position and sort the remaining items in the list in descending order.

Output a space separated list of the items after rotation and sorting.

=cut

my $in = *STDIN;
my $test;
my $arg = $ARGV[0] || '';
if ($arg eq '--test') {
	$test = 1;
	$in = *DATA;
}
my $debug = 0;#$test;

my $count;
my @Items = ();
my $rotate;
my @Ordered = ();

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
		$count = undef;
		@Items = ();
		@Ordered = ();
		$rotate = undef;
		next;
	}
	my @Input = split(/\s+/, $input);
	my $values = scalar(@Input);

	if (!$count) {
		die "You should provide a single count value for the number of items in the list, you provided $values: $input\n" unless $values == 1;
		$count = shift(@Input);
		die "You should provide a positive count value for the number of items in the list, you gave: $input\n" unless $count > 0;
	} elsif (!scalar(@Items)) {
		die "You specified a sequence of $count numbers, but provided $values" if ($values != $count);
		@Items = map {
			my $value = $ARG;
			die "You should provide an integer value, you gave $value: $input\n" unless $value =~ m{\A[-+]?\d+\z}xms;
			$value
		} @Input;
	} elsif (!$rotate) {
		die "You should provide a single value for the number of initial items in the list to rotate right, you provided $values: $input\n" unless $values == 1;
		$rotate = shift(@Input);
		die "You should provide a non-negative value for the number of initial items to rotate right, you gave: $input\n" if $rotate < 0;
		die "The number of initial items to rotate right cannot exceed the length of the list($count), you gave: $input\n" if $rotate > $count;

		@Ordered = get_order($rotate, \@Items);

		if (!$test) {
			my $order = join(" ", @Ordered);
			print qq{$order\n};
			exit 0;
		}
	}
}

sub get_order {
	my ($initial, $raItems) = @ARG;
	my $count = scalar(@$raItems);
	my @Order = ();
	if ($initial > 0) {
		my @First = @{$raItems}[$initial - 1,0..($initial - 2)];
		my @Rest = @{$raItems}[$initial..($count - 1)];
		print qq{First: @{[Dumper(\@First)]}\nRest: @{[Dumper(\@Rest)]}\n} if $debug;
		@Order = @First;
		push(@Order, sort { $b <=> $a} @Rest);
	} else {
		@Order = sort { $b <=> $a} @$raItems;
	}
	return @Order;
}

__DATA__
8
7 43 12 4 13 78 6 1
4
#=4 7 43 12 78 13 6 1
8
7 43 12 4 13 78 6 1
0
#=78 43 13 12 7 6 4 1
8
7 43 12 4 13 78 6 1
1
#=7 78 43 13 12 6 4 1
8
7 43 12 4 13 78 6 1
8
#=1 7 43 12 4 13 78 6
8
7 43 12 4 13 78 6 1
9
#=err