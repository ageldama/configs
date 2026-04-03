#!/usr/bin/env perl

use utf8;
use warnings;
use strict;
use feature qw(say);
use Getopt::Std qw(getopts);
use Data::Dumper;

sub HELP_MESSAGE {
    print STDERR <<"EO_HELP";
  -s : size limit (in bytes, default = 100 MiB)
  -f : output filename

Exiting.
EO_HELP

    exit 0;
}

my %opts = (
    s => 1024 * 1024 * 100, # 100-MiB
    f => undef,
    h => undef,
);
getopts( 'hs:f:', \%opts );

HELP_MESSAGE if defined($opts{h});
HELP_MESSAGE unless defined($opts{f});

say Dumper(\%opts);

# TODO

while (<STDIN>) {
  # TODO
}


