#!/usr/bin/env perl

use strict;
use warnings;
use DDP;

BEGIN {
    our @rows = ();
}

END {
    our @rows;
    my @sorted = sort { $a->[2] cmp $b->[2] } @rows;
    @sorted = reverse @sorted;

    my $sum = 0;
    foreach (@sorted) {
        $sum += $_->[2];
        print "$_->[0]\t$_->[1]\t$_->[2]\n";
    }

    print STDERR "SUM: $sum\n";
}

while (<STDIN>) {
    next unless /^(?<tag>[^ .]+) REQ (?<lib>[^ .]+).+\belapsed\b(?<elapsed>.+)$/;
    my ($tag, $lib, $elapsed) = ($+{tag}, $+{lib}, $+{elapsed});
    our @rows;
    push @rows, [$tag, $lib, $elapsed];
}
