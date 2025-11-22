#!/usr/bin/env perl

package ScriptRofi::HistoryDB::Storable;

use strict;
use warnings;

use Storable;
use Carp;
use Data::Dumper;


sub new {
  my $db_path = shift;

  return bless {
    scripts => {},
    db_path => $db_path,
   };
}


sub update_paths {
  my ($self, $scripts) = @_;
  my $db_path = $self->{db_path};

  if(-r $db_path){
    $self->{scripts} = retrieve($self->{db_path})
      or carp "Storable retrieve failed: $!";
  }
  my $h = $self->{scripts};

  foreach my $s (@$scripts) {
    if(!exists($h->{$s})){
      # print "UPD: $s\n";
      $h->{$s} = {
        last => time,
      };
    }
  }

  store($h, $db_path) or croak "Storable store failed: $!";
}


sub list_sorted {
  my ($self) = @_;

  $self->{scripts} = retrieve($self->{db_path})
    or croak "Storable retrieve failed: $!";
  my $h = $self->{scripts};

  my @sorted_keys = reverse (sort {$h->{$a}->{last} cmp $h->{$b}->{last}} keys %$h);

  return [@sorted_keys];
}


sub update_sel {
  my ($self, $sel, $sel_type) = @_;

  my $db_path = $self->{db_path};
  my $h = $self->{scripts};

  $h->{$sel}->{last} = time;

  my $sel_type_k = "sel_" . $sel_type;
  $h->{$sel}->{$sel_type_k} ++;

  store($h, $db_path) or croak "Storable store failed: $!";
}


sub most_sel_type {
  my ($self, $sel) = @_;

  my $db_path = $self->{db_path};
  my $h = $self->{scripts};

  if(exists($h->{$sel})){
    my %sels = ();
    foreach my $k (keys %{$h->{$sel}}) {
      next unless $k =~ /^sel_(?<sel_type>\d+)/;
      # print "$k $+{sel_type} \n";
      $sels{$+{sel_type}} = $h->{$sel}->{"sel_$+{sel_type}"};
    }
    if(scalar keys %sels > 0){
      my @ranked = reverse (sort {$sels{$a} cmp $sels{$b}} keys %sels);
      return $ranked[0];
    }
  }

  return -1; # fallback
}


1;  # ScriptRofi::HistoryDB::Storable



package ScriptRofi::HistoryDB::Dummy;


sub new {
    my ($db_path, $flag_file) = @_;

    return bless {
        scripts => [],
        flag_file => $flag_file,
    };
}


sub update_paths {
    my ($self, $scripts) = @_;
    $self->{scripts} = $scripts;
}


sub list_sorted {
    my ($self) = @_;
    return $self->{scripts};
}


sub update_sel {
}


sub most_sel_type {
  my ($self, $sel) = @_;
  return -1;
}


1; # ScriptRofi::HistoryDB::Dummy;



package main;

use strict;
use warnings;
use feature qw(say);
use File::Find;
use IPC::Open2;
use Getopt::Std;
use Data::Dumper;


our $VERSION = '0.0.1';

use constant NO_HISTORY_DB_FLAG_FILE => "$ENV{HOME}/.no-db-scripts-rofi";

my %opts = (
  p => 0, s => 0, e => 0,
  S => "$ENV{HOME}/local/scripts:$ENV{HOME}/P/v3/bin",
  D => "$ENV{HOME}/.scripts-rofi.storable",
  T => "x-terminal-emulator -e",
 );
getopts('psreS:D:T:', \%opts);

# say Dumper(\%opts);

sub HELP_MESSAGE {
  my $fh = shift;
  print $fh <<"EO_HELP";
NO_DB_FLAG_FILE:  ${ \NO_HISTORY_DB_FLAG_FILE }

List content of SCRIPT_DIRS and ask to select:

  -p : print selection
  -s : save selection
  -e : execute selection
  -S SCRIPT_DIRS      : `:'-separated list
  -D HIST_DB_FILE
  -T XTERM_COMMAND

Exiting.
EO_HELP

  exit 0;
}


my $USE_HISTORY_DB = ! -r NO_HISTORY_DB_FLAG_FILE;

my $history_db = ScriptRofi::HistoryDB::Dummy::new($opts{D}, NO_HISTORY_DB_FLAG_FILE);
$history_db = ScriptRofi::HistoryDB::Storable::new($opts{D}) if $USE_HISTORY_DB;
#p $history_db;

# main
my @scripts = ();

foreach my $dir (split /:/, $opts{S}) {
  find(
    {
      wanted => sub {
        my $fn = $File::Find::name;
        return if -d $fn;

        push @scripts, $fn;
      },
      follow => 1,
    },
    $dir
   );
}
# use Data::Dumper;
# print Dumper(\@scripts), "\n";


$history_db->update_paths(\@scripts);

my $scripts_sorted = $history_db->list_sorted;


my $pid = open2(my $chld_out, my $chld_in,
                'rofi -dmenu -p "Select a script to run (Shift-Enter == run-in-terminal)" -kb-accept-alt "" -kb-custom-1 "Shift+Return" '
               ) or die;
# say "rofi-pid: $pid";

print $chld_in "$_\n" foreach @$scripts_sorted;

close($chld_in) or die;

# reap zombie and retrieve exit status
waitpid( $pid, 0 );
my $child_exit_status = $? >> 8;
# say "rofi-exitcode: $child_exit_status";

if($child_exit_status != 0 && $child_exit_status != 10){
  close($chld_out);
  die 'bye: cancelled';
}

#
my $stdout = <$chld_out>;
# print "[$stdout]\n";
chomp $stdout;

close($chld_out) or die;


my $sel_type = 0;
if($child_exit_status == 10){
  $sel_type = 1;
}


my $most_sel_type = $history_db->most_sel_type($stdout);


if($opts{s}){
  $history_db->update_sel($stdout, $sel_type);
}

if($opts{p}){
  print "$stdout\n";
  if($sel_type == 1){
    print "# with terminal: '$opts{T}'\n";
  }
}

if($opts{e}){
  if($sel_type == 1){
    exec($opts{T} . " " . $stdout);
  }else{
    exec($stdout);
  }
}

#EOF.
