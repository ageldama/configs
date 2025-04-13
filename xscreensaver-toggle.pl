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
}elsif(-e "$ENV{HOME}/.use-xss-lock"){
  # xss-lock:
  print "xss-lock selected\n";

  sub xset_q__screensaver_timeout {
    my $xset_q = qx<xset q>;
    $xset_q =~ /Screen Saver:.+timeout:\s+(?<timeout>\d+)/s;
    $+{timeout} + 0;
  }

  my $xset_s_setting = qx<cat ~/.use-xss-lock>;
  chomp $xset_s_setting;

  $xset_s_setting += 0 if $xset_s_setting;
  $xset_s_setting = 60 * 10 unless $xset_s_setting;

  print "~/.use-xss-lock || DEFAULT = [${xset_s_setting}]\n";

  my $cur_xset_s_timeout = xset_q__screensaver_timeout;

  if ($cur_xset_s_timeout == 0) {
    system(qq<xset s ${xset_s_setting}>);
  } else {
    system(qq<xset s off>);
  }

  my $new_timeout = xset_q__screensaver_timeout;
  my $msg = "Changed to: xset s ${new_timeout}";
  qx[notify-send '$msg'];
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




