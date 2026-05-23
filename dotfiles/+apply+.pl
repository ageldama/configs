#!/usr/bin/env perl
use strict;
use warnings;
use Data::Dumper;
use Getopt::Std;
use IO::File;

{
    my %opts = (u => 0);
    getopts('u', \%opts);

    my $inst_or_uninst = 'i';
    $inst_or_uninst = 'u' if $opts{u};

    #
    my $fn = 'dirs.config';
    my $fh = IO::File->new($fn, '<') or die "Could not open $fn: $!";

    while(my $line = <$fh>)  {
        next if $line =~ '^[\s]+$';  # skip: whitespaces
        next if $line =~ '^#.*$';    # skip: comment

        # Script?
        if($line =~ m/^CUSTOM:\s+(?<custom_script>.+)$/){
          my $script = $+{custom_script};
          print "* CUSTOM: $script $inst_or_uninst\n";
          system("$script $inst_or_uninst");
          print "\n\n";
          next;
        }

        # otherwise: SRC    DEST   PRED
        my ($dot_dir, $dst_dir, $pred) = split /\s+/, $line;

        qx/$pred/;
        my $ok_to_go = $? == 0;
        print "* [[ $dot_dir ]]\n";
        print "\t- PRED:\t$pred\n";
        print "\t- DEST:\t$dst_dir\n";
        print "\t- ", ($ok_to_go ? "APPLYING ..." : "SKIPPING."), "\n";
        if ($ok_to_go) {
            system("./_inst.pl $inst_or_uninst \"$dot_dir\" \"$dst_dir\"");
        }
        print "\n\n";
    }

    close $fh;
}

