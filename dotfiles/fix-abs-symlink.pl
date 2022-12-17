#!/usr/bin/env perl
use strict;
use warnings;
use File::Spec;

for my $fn (@ARGV) {
    my $resolved = readlink $fn;
    if ($resolved =~ m/^\//) {
        print "$resolved\n";

        # TODO
        print "\t===> " . File::Spec->abs2rel($resolved) . "\n";

    } else {
        print "*OK:SKIP*\n";
    }
}
