#!/usr/bin/env perl

use utf8;
use strict;
use warnings;

use File::Find;
use Getopt::Long;

my $really_delete = 0;
my $show_help = 0;

GetOptions(
  'help|h' => \$show_help,
  'delete|D' => \$really_delete,
 );


if($show_help){
  print STDERR "$0 [-h|--help] [-D|--delete]\n";
  exit 255;
}


my %winners = ();
my @to_be_deleteds = ();

find({
  wanted => sub {
    return unless -f;

    my $sname = $_;
    my $fname = $File::Find::name;

    if(defined $winners{$sname}){
      my $stored_fname = $winners{$sname};
      if(length $stored_fname > length $fname){
        # stored-wins: PRINT current
        print "# longer:\t$stored_fname\n";
        print "\t$fname\n";
        push @to_be_deleteds, $fname;
      }else{
        # challenger-wins: PRINT stored, UPDATE stored
        print "# longer:\t$fname\n";
        print "\t\t$stored_fname\n";
        $winners{$sname} = $fname;
        push @to_be_deleteds, $stored_fname;
      }
    }else{
      $winners{$sname} = $fname;
    }
  },
  follow => 1,
}, qw(.));


if($really_delete){
  print "===> DELETING:\n";
  foreach my $del (@to_be_deleteds) {
    print "DEL:\t$del\n";
    unlink $del or warn "FAIL($!)\n";
  }
  print "===> DELETED.\n";
}else{
  print "===> DRY-RUN HAS FINISHED.\n";
}
