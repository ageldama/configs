#!/usr/bin/env perl
use strict;
use warnings;
use feature qw(say);
use Data::Dumper;


sub rand_ncolors {
    return 1 + int(rand(10));
}

sub rand_color {
    return sprintf("#%02x%02x%02x", int(rand(256)), int(rand(256)), int(rand(256)));
}

my @colors = map { sprintf("-add '%s'", rand_color()); } (1 .. rand_ncolors);
my $gradient_colors = join " ", @colors;
my $cmd = sprintf("hsetroot %s -gradient %d", $gradient_colors, int(rand(360)));
say $cmd;
system($cmd);



