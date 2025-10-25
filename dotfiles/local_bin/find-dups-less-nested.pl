#!/usr/bin/env perl

use utf8;
use strict;
use warnings;

use File::Find;
use Getopt::Long::Descriptive;


my ($opt, $usage) = describe_options(
  '%c %o',
  [ 'delete|D' => 'Delete dupe-files' ],
 );


if(!$opt || $opt->{help}){
  print $usage->text;
  exit;
}

my $really_delete = defined $opt->{delete};


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
