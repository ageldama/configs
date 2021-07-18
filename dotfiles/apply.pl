#!/usr/bin/env perl
use strict;
use warnings;
use Data::Dumper;
use Getopt::Std;

{
    my %opts = (u => 0);
    getopts('u', \%opts);

    $ENV{DOTFILES_UNINST} = 1 if $opts{u};

    #
    my $fn = 'dirs.config';
    open(my $fh, $fn) or die "Could not open $fn: $!";

    while(my $line = <$fh>)  {
        next if $line =~ '^[\s]+$';
        next if $line =~ '^#.+$';
        my ($dot_dir, $dst_dir, $pred) = split /\s+/, $line;

        qx/$pred/;
        my $ok_to_go = $? == 0;
        print "* DOT=$dot_dir  DST=$dst_dir  PRED=$pred ==> ", ($ok_to_go ? "OK" : "SKIP"), "\n";
        if ($ok_to_go) {
            system("sh ./_inst.sh \"$dot_dir\" \"$dst_dir\"");
        }
        print "------------------\n\n";
    }

    close $fh;
}

