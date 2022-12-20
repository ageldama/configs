#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;
use List::Util qw(first);

sub get_default_sink {
  qx{pactl info} =~ m/default sink:\s+(.+)/i && return $1;
}

sub get_sinks {
  map { /^\s+Name:\s+(.+)/ && $1 } grep /^\s+Name:/, qx{pactl list sinks};
}

sub find_next_sink {
  my ($cur, $sinks) = @_;

  my $len = scalar @$sinks;

  if($len == 1){
    return $cur;
  }

  my $index = first { $sinks->[$_] eq $cur } 0..($len-1);

  $index ++;
  $index = 0 if $index >= $len;

  return $sinks->[$index];
}

# main:

my @sinks = get_sinks;
die "No sinks" if scalar @sinks == 0;
# print Dumper(\@sinks) . "\n";

my $cur = get_default_sink;
# print "$cur\n";

my $next_sink = find_next_sink($cur, \@sinks);
# print $next_sink;

qx{pactl set-default-sink $next_sink};
print $next_sink;

#EOF.
