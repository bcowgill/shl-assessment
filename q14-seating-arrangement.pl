#!/usr/bin/env perl
use strict;
use warnings;
use English qw(-no-match-vars);
use Data::Dumper;

=pod

PROBLEM STATEMENT:

Given a line of text containing the number of dinner attendees.
The next line contains space separated numbers representing the id of the person each attendee prefers to sit next to.

Given that their id's begin at 1 and range up to the number of attendees.
Given that a person will only attend if they get to sit next to their preferrd person at a circular table.
Work out a seating arrangemnt that allows the most people to attend the dinner.

Output a space separated seating arrangement in order of increasing attendee id's. If more than one seating arrangement exists return the one that is lexicographically smallest.

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
my @Friends = ();
my @Seating = ();

while (my $input = <$in>) {
	chomp($input);
	if ($input =~ m{\A#=(.+)\z})
	{
		next if !$test;
		my $expected = $1;

		my $got = join(" ", @Seating);

		if ($got eq $expected) {
			print qq{$got\n};
		} else {
			print qq{NOT OK expected: ($expected) but got ($got)\n};
		}
		$count = undef;
		@Friends = ();
		@Seating = ();
		next;
	}
	my @Input = split(/\s+/, $input);
	my $values = scalar(@Input);

	if (!$count) {
		die "You should provide a single count value for the number of responding attendees, you provided $values: $input\n" unless $values == 1;
		$count = shift(@Input);
		die "You should provide a positive count value for the number of responding attendees, you gave: $input\n" unless $count > 0;
	} else {
		die "You specified a sequence of $count numbers, but provided $values" if ($values != $count);
		@Friends = map {
			my $friend = $ARG;
			die "You should provide a positive value representing the attendee Id of their friend, you gave $friend: $input\n" if $friend < 1;
			$friend
		} @Input;

		@Seating = get_seating(\@Friends);

		if (!$test) {
			my $seating = join(" ", @Seating);
			print qq{$seating\n};
			exit 0;
		}
	}
}

sub get_seating {
	my ($raFriends) = @ARG;
	my $total = scalar(@$raFriends);
	my $most_guests = 0;
	my @Solutions = ();

	print qq{Friends:@{[Dumper($raFriends)]}} if $debug;

	foreach my $start (1 .. $total) {
		my @Order = try_seating($start, $raFriends);
		my $guests = scalar(@Order);
		if ($guests > $most_guests) {
			$most_guests = $guests;
			@Solutions = (\@Order);
			if ($debug) {
				print qq{Best So Far: $most_guests, @{[Dumper(\@Order)]}\n};
			}
		} elsif ($guests == $most_guests) {
			push(@Solutions, \@Order);
			if ($debug) {
				print qq{Another Solution: $most_guests, @{[Dumper(\@Order)]}\n};
			}
		}
		if ($guests >= $total) {
			# shortcut if it is already the best solution...
			return @{$Solutions[0]};
		}
	}
	# if multiple solutions, the first one found is lexicographically lowest already.	
	# if (scalar(@Solutions) > 1) {
	# 	print qq{limit one solution from @{[scalar(@Solutions)]}\n};
	# }
	return @{$Solutions[0]};
}

sub try_seating {
	my ($start, $raFriends) = @ARG;

	my $total = scalar(@$raFriends);
	my $idx = $start - 1;

	my %Seated = ();
	my @Order = ();

	print qq{Try from $start\n} if $debug;
	assign_seat($start, $raFriends, \@Order, \%Seated);

	foreach my $index (0 .. ($total - 1)) {
		next if $index == $idx;
		next if $Seated{$index + 1};
		unless (assign_seat($index + 1, $raFriends, \@Order, \%Seated)) {
			return ();
		}
	}
	return @Order;
}

sub assign_seat {
	my ($id, $raFriends, $raOrder, $rhSeated) = @ARG;
	print qq{Assign: $id\n} if $debug;
	my $next = $id;
	while (!$rhSeated->{$next}) {
		$rhSeated->{$next} = 1;
		push(@$raOrder, $next);
		$next = $raFriends->[$next - 1];
	}
	return check_seating($raOrder, $raFriends);
}

sub check_seating {
	my ($raOrder, $raFriends) = @ARG;
	my $length = scalar(@$raOrder);

	foreach my $idx (0 .. ($length - 1)) {
		my $guest = $raOrder->[$idx];
		my $friend = $raFriends->[$guest - 1];
		my $rhNeighbours = get_neighbour($idx, $raOrder);
		if ($rhNeighbours->{prev} != $friend && $rhNeighbours->{next} != $friend) {
			print qq{Bad Seating Arrangement for guest $guest wants to be next to $friend, not $rhNeighbours->{prev} or $rhNeighbours->{next}\n@{[Dumper($raOrder)]}} if $debug;
			return 0;
		}
	}
	return 1;
}

sub get_neighbour {
	my ($idx, $raOrder) = @ARG;
	my $length = scalar(@$raOrder);
	my %Neighbours = ();
	$Neighbours{prev} = $raOrder->[$idx - 1];
	$Neighbours{next} = $raOrder->[($idx + 1) % $length];
	print qq{Neighbours: @{[Dumper(\%Neighbours)]}} if $debug;
	return \%Neighbours;
}

# MUSTDO handle the last two examples in DATA
__DATA__
4
2 3 4 1
#=1 2 3 4
4
2 3 2 1
#=1 2 3 4
4
2 4 2 2
#=1 2 4
8
2 3 1 5 4 7 6 1
#=4 5 6 7
