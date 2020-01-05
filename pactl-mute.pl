#!/usr/bin/env perl
use strict;
use warnings;
use feature qw(say);

package pactl;

use Data::Dumper;

sub new {
  my $sth = shift; # 'source' or 'sink'.
  my $self = {sth => $sth};
  bless $self;
  return $self;
}

sub plural {
  return shift . 's';
}

sub sth {
  my $self = shift;
  return $self->{sth};
}

sub sth_plural {
  my $self = shift;
  return $self->sth . 's';
}

sub all_names {
  my $self = shift;
  my $sth = $self->sth_plural;
  my @a = qx[pactl list short $sth | awk -F'\t' '{print \$2}'];
  chomp(@a);
  return @a;
}

sub description {
  my ($self, $name) = @_;
  my $sth = $self->sth_plural;

  my $name_found = undef;

  foreach my $line (qx[pactl list $sth]) {
    chomp $line;
    if ($name_found) {
      if ($line =~ /Description: (.+)$/) {
        return $1;
      }
    } else {
      $name_found = $line =~ /${name}/;
    }
  }
}

sub is_muted {
  my ($self, $name) = @_;
  my $sth = $self->sth_plural;

  my $name_found = undef;

  foreach my $line (qx[pactl list $sth]) {
    chomp $line;
    if ($name_found) {
      if ($line =~ /Mute: (.+)$/) {
        return ($1 eq 'yes') || 0;
      }
    } else {
      $name_found = $line =~ /${name}/;
    }
  }
  return 0;
}

sub mute {
  my ($self, $name) = @_;
  my $sth = $self->sth;

  return qx[pactl set-${sth}-mute "${name}" 1];
}

sub toggle_mute {
  my ($self, $name) = @_;
  my $sth = $self->sth;

  return qx[pactl set-${sth}-mute "${name}" toggle];
}


sub find_default {
  my $self = shift;
  my $sth = $self->sth;

  foreach my $line (qx[pactl info]) {
    if ($line =~ /default ${sth}: (.+)/i) {
      return $1;
    }
  }
}

sub mute_all {
  my $self = shift;
  my %result = ();
  foreach my $i ($self->all_names) {
    $self->mute($i);
    my $desc = $self->description($i);
    my $muted = $self->is_muted($i);
    $result{$i} = [$desc, $muted];
  }
  return %result;
}

sub mute_default_only {
  my $self = shift;
  my $i = $self->find_default;
  $self->mute($i);
  return $i, $self->description($i), $self->is_muted($i);
}

sub toggle_mute_default_only {
  my $self = shift;
  my $i = $self->find_default;
  $self->toggle_mute($i);
  return $i, $self->description($i), $self->is_muted($i);
}


1;

package notify_send;

sub new {
  my $self = {};
  $self->{notify_send_cmd} = `which notify-send`;
  chomp $self->{notify_send_cmd};
  bless $self;
  return $self;
}

sub puts {
  my ($self, $str) = @_;
  my $cmd = $self->{notify_send_cmd};
  if ($cmd) {
    qx[$cmd '$str'];
  } else {
    print STDERR "$str\n";
  }
}

1;


#
package main;

my $argv_len = scalar @ARGV;
if ($argv_len < 2) {
  say STDERR <<EO_HELP;
$0 [source|sink] [all|default|toggle_default]

Usage:
  $0 source all    # Mute every source.
  $0 sink default  # Mute only default sink.
  $0 sink toggle_default  # Toggle mute default sink.
EO_HELP
  die;
}

unless ($ARGV[0] =~ /sink|source/) {
  die "Only 'sink' or 'source' allowed, not '${ARGV[0]}'!";
}

my $pactl = pactl::new $ARGV[0];
my $notify_send = notify_send::new;

sub notify_mute {
  my ($name, $desc, $muted) = @_;
  my $sth = $pactl->sth;
  $notify_send->puts(sprintf("%s: %s (%s) has %s.", $sth, $name, $desc,
    $muted ? 'muted' : 'unmuted'));
}

if ($ARGV[1] eq 'all') {
  my %result = $pactl->mute_all;
  $, = "\t";
  foreach my $k (keys %result) {
    my $i = $result{$k};
    say $k, $i->[0], $i->[1];
    notify_mute($k, $i->[0], 1);
  }
} elsif ($ARGV[1] eq 'default') {
  my @result = $pactl->mute_default_only;
  $, = "\t";
  say $result[0], $result[1], $result[2];
  notify_mute($result[0], $result[1], 1);
} elsif ($ARGV[1] eq 'toggle_default') {
  my @result = $pactl->toggle_mute_default_only;
  $, = "\t";
  say $result[0], $result[1], $result[2];
  notify_mute($result[0], $result[1], $result[2]);
} else {
  die "Only 'default' or 'all' or 'toggle_default' allowed, not '${ARGV[1]}'!";
}

