#!/usr/bin/env perl
use strict;
use warnings;

sub rand_range {
    my ($start, $end) = @_;
    return $start + int rand $end - $start + 1;
}

srand(time);

while (1) {
    my $idle = int `xprintidle`;
    if ($idle > 2000) {
        my $delta_x = rand_range(-100, 100);
        my $delta_y = rand_range(-100, 100);
        my $cmd = "xdotool mousemove_relative -- ${delta_x} ${delta_y}";
        system($cmd);
    }
    sleep(0.5);
}

