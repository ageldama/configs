#!/usr/bin/env perl

use utf8;
use strict;
use warnings;

use File::Find;


my %winners = ();


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
      }else{
        # challenger-wins: PRINT stored, UPDATE stored
        print "# longer:\t$fname\n";
        print "\t\t$stored_fname\n";
        $winners{$sname} = $fname;
      }
    }else{
      $winners{$sname} = $fname;
    }
  },
  follow => 1,
}, qw(.));
