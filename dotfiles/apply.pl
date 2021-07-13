#!/usr/bin/env perl
use strict;
use warnings;
use Data::Dumper;

{
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
    }

    close $fh;
}

# TODO export DOTFILES_UNINST=$1

# while read p; do
#   echo "${p}" | awk '{print "###", $1, "\t==>\t", $2; system(sprintf("sh ./_inst.sh \"%s\" \"%s\"", $1, $2)); }'
# done <dirs.config

