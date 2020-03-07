#!/usr/bin/env perl
use strict;
use warnings;
use feature qw(say);
use Data::Dumper;


sub rand_color {
    return sprintf("#%02x%02x%02x", int(rand(256)), int(rand(256)), int(rand(256)));
}

my $c = rand_color;

system(sprintf("hsetroot -solid '%s'", $c));
system(sprintf("notify-send '%s'", $c));



