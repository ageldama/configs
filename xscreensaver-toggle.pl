#!/usr/bin/env perl
use strict;
use warnings;
use feature qw(say);

package main;

my $pid = `pgrep -u \`id -u\` ^xscreensaver\$`;
chomp $pid;

if ($pid) {
  qx[xscreensaver-command -exit];
  qx[notify-send 'xscreensaver has killed'];
} else {
  my $pid = fork();
  if ($pid == 0) {
    qx[notify-send 'xscreensaver has started'];
    exec('xscreensaver', '-no-splash');
  }
}





