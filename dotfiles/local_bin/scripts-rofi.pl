#!/usr/bin/env perl

use strict;
use warnings;
use feature qw(say);
use File::Find;
use IPC::Open2;
use DDP;
use Getopt::Std;

my %opts = (p => 0);
getopts('p', \%opts);

use constant SCRIPT_DIR => "$ENV{HOME}/local/scripts";

# main
my @scripts = ();

find(
    {
        wanted => sub {
            my $fn = $File::Find::name;
            return if -d $fn;

            push @scripts, $fn;
        },
        follow => 1,
    },
    SCRIPT_DIR
   );

my $pid = open2(my $chld_out, my $chld_in,
                'rofi -dmenu -p "Select a script to run"'
               ) or die;
# say "rofi-pid: $pid";

print $chld_in "$_\n" foreach @scripts;

close($chld_in) or die;

# reap zombie and retrieve exit status
waitpid( $pid, 0 );
my $child_exit_status = $? >> 8;
# say "rofi-exitcode: $child_exit_status";

if($child_exit_status != 0){
  close($chld_out);
  die 'bye: cancelled';
}

#
my $stdout = <$chld_out>;
chomp $stdout;

close($chld_out) or die;

if($opts{p}){
  print "$stdout\n";
}else{
  system($stdout);
}

#EOF.
