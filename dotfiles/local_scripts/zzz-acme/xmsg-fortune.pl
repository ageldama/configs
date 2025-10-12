#!/usr/bin/env perl

use strict;
use warnings;
use Data::Dumper;
use File::Find;


use constant BASE_DIRS => qw(/usr/share/games/fortunes /usr/local/share/games/fortune);


sub remove_ext {
    $_ = shift; s/\.dat$//r;
}


my @dirs = grep { -d } BASE_DIRS;


my @dat_filenames = ();

find(sub {
    if (-f $_ && $_ =~ /.dat$/) {
        if ($^O eq 'freebsd') {
            push @dat_filenames, remove_ext($File::Find::name);
        } else {
            push @dat_filenames, remove_ext($_);
        }
    }
}, @dirs);

print STDERR Dumper(@dat_filenames), "\n";

die "$0: no fortune data found" unless 0 < scalar @dat_filenames;

my $dat = $dat_filenames[int(rand(scalar @dat_filenames))];

print STDERR $dat, "\n";

my $cmd = <<EO_CMD;
xmessage "\$(fortune -a $dat)" \\
  -title "fortune: $dat" \\
  -default okay -center \\
  -fn 12x24 \\
  -bg black -fg '#ffbf00'
EO_CMD

print STDERR $cmd, "\n";
exec $cmd;

