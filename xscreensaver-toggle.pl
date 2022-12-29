#!/usr/bin/env perl
use strict;
use warnings;
use feature qw(say);

package main;

my $pid;

if(-e "$ENV{HOME}/.use-xautolock"){
  # xautolock:
  print "xautolock selected\n";

  $pid = `pgrep -u \`id -u\` ^xautolock\$`;
  chomp $pid;

  if($pid){
    qx[xautolock -exit];
    qx[notify-send 'xautolock has killed'];
  }else{
    my $pid = fork();
    if ($pid == 0) {
      qx[notify-send 'xautolock has started'];
      exec('xautolock');
    }
  }

}else{
  print "xscreensaver selected\n";

  # xscreensaver:
  $pid = `pgrep -u \`id -u\` ^xscreensaver\$`;
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
}




