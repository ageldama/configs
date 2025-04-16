#!/usr/bin/env perl

use File::Temp qw(tempfile);

my ($fh, $fn) = tempfile(SUFFIX => '.html');
while (<STDIN>) { print $fh $_; }

close($fh);

print STDERR "$fn\n";

system("xdg-open $fn");
unlink $fn;

