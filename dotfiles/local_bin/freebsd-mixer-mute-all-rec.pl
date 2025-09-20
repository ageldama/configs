#!/usr/bin/env perl

use strict;
use warnings;

use Data::Dumper;

my @pcm_lines = grep(/^pcm.+\:/, qx<mixer -a -s>);

my %pcms = ();

foreach my $l (@pcm_lines) {
  $l =~ m/^(?<name>pcm(?<num>\d+))\:/;
  my $pcm = $+{name};
  my $num = $+{num};
  my $dev = "/dev/mixer$num";

  # print $pcm, " => ", $dev, "\n";

  # (eg) mixer -f /dev/mixer1 rec.mute=on
  my $stdout = qx<mixer -f $dev rec.mute=on>;
  qx<notify-send "$stdout">;
}

