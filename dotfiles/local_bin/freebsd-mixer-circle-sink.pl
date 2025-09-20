#!/usr/bin/env perl

use strict;
use warnings;

use Data::Dumper;

my @pcm_lines = grep(/^pcm.+\:/, qx<mixer -a>);

my %pcms = ();

foreach my $l (@pcm_lines) {
  $l =~ m/^(?<name>pcm.+)\:/;
  my $pcm = $+{name};

  $l =~ m/(?<default>\(default\))/;
  $pcms{$pcm} = defined $+{default};
}

# print Dumper(\%pcms);
my $cur = 0;
while (scalar keys(%pcms)) {
  foreach my $pcm (sort(keys %pcms)) {
    if ($cur) {
      my $stdout = qx<mixer -d $pcm>;
      qx<notify-send "$stdout">;
      goto BYE;
    }

    $cur = 1 if $pcms{$pcm};
  }
}
BYE:
