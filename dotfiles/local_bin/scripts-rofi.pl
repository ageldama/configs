#!/usr/bin/env perl

use strict;
use warnings;
use feature qw(say);
use File::Find;
use IPC::Open2;
use DDP;
use Getopt::Std;


our $VERSION = '0.0.1';

my %opts = (p => 0, s => 0, r => 0, e => 0);
getopts('psre', \%opts);

use constant SCRIPT_DIR => "$ENV{HOME}/local/scripts";
use constant SEL_SAVE => "$ENV{HOME}/.scripts-rofi.sh";


sub HELP_MESSAGE {
  my $fh = shift;
  print $fh <<"EO_HELP";
List content of [${ \SCRIPT_DIR }] and ask to select:

  -p : print selection
  -s : save selection to [${ \SEL_SAVE }]
  -r : rerun saved selection [${ \SEL_SAVE }]
  -e : execute selection

Exiting.
EO_HELP

  exit 0;
}

# rerun?
if($opts{r}){
  if(-x SEL_SAVE){
    exit system(SEL_SAVE);
  }else{
    die 'No saved selection (exiting): ' . SEL_SAVE;
  }
}

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

if($opts{s}){
  open(my $fh_out, '>', SEL_SAVE) or die;
  print $fh_out "$stdout\n";
  close($fh_out);

  chmod(0700, SEL_SAVE) or die;
}

if($opts{p}){
  print "$stdout\n";
}elsif($opts{e}){
  system($stdout);
}

#EOF.
