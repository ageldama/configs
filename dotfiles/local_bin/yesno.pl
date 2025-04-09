#!/usr/bin/env perl

use strict;
use warnings;

use Carp;
use IPC::Open2;

my $q = "really???";
$q = $ARGV[0] if scalar @ARGV >0;

my $pid = open2(
  my $stdout, my $stdin,
  "rofi -dmenu -p '$q' -sep '\\0' -eh 2 -markup-rows -format i"
 ) or confess;

print $stdin "<span size='x-large' weight='heavy'>Yes</span>\0";
print $stdin "<span size='x-large' weight='heavy'>No</span>\0";
close($stdin);

my $stdout_ = do { local($/); <$stdout> };
close($stdout);
chomp $stdout_;

waitpid($pid, 0);
my $exit_code = $? >> 8;
# print STDERR "exit_code: $exit_code\n";

if ($exit_code == 0 && $stdout_ == 0) {
  exit 0;
} else {
  exit -1;
}
