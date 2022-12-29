#!/usr/bin/env perl
use strict;
use warnings;
use feature qw(say);

package main;

my $pid;

if(-e "$ENV{HOME}/.use-xautolock"){
  print "xautolock selected\n";
  qx[xautolock -locknow];
}else{
  print "xscreensaver selected\n";
  qx[xscreensaver-command -lock];
}




