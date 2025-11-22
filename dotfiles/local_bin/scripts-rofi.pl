#!/usr/bin/env perl

package ScriptRofi::HistoryDB::Sqlite3;

use strict;
use warnings;

use DBI;


sub open_or_create {
  my $db_path = shift;

  my $dbh = DBI->connect("dbi:SQLite:dbname=$db_path", '', '',
                         { RaiseError => 1, AutoCommit => 0, });

  $dbh->{sqlite_allow_multiple_statements} = 1;

  $dbh->do(<<'EO_SQL');
create table if not exists hist (
  path    text primary key,
  cnt     integer default 0 not null,
  mtime   integer default 0 not null
);

create index if not exists hist_ix_cnt
    on hist (cnt);

create index if not exists hist_ix_mtime
    on hist (mtime);
EO_SQL

  $dbh->commit;
  $dbh->{sqlite_allow_multiple_statements} = 0;

  return bless {
    dbh => $dbh,
   };
}


sub update_paths {
  my ($self, $scripts) = @_;
  my $dbh = $self->{dbh};

  my $sth = $dbh->prepare_cached(<<'EO_SQL');
insert into hist (path, cnt, mtime)
    values (?, 0, current_timestamp)
on conflict (path)
    do update set mtime = current_timestamp
EO_SQL

  foreach my $s (@$scripts) {
    $sth->execute($s);
  }

  $dbh->commit;
}


sub list_sorted {
  my ($self) = @_;
  my $dbh = $self->{dbh};

  my $sth = $dbh->prepare_cached(<<'EO_SQL');
select path from hist
    where 1=1 /* and path like ? || '%' */
    order by mtime desc, cnt desc
EO_SQL

  # $sth->bind_param(1, $base_dir);
  $sth->execute;

  my @result = ();

  while ( my @row = $sth->fetchrow_array ) {
    push @result, $row[0];
  }

  $dbh->rollback;

  return \@result;
}


sub update_sel {
  my ($self, $sel) = @_;
  my $dbh = $self->{dbh};

  my $sth = $dbh->prepare_cached(<<'EO_SQL');
update hist
    set cnt = cnt + 1
        ,mtime = current_timestamp
    where path = ?
EO_SQL

  $sth->execute($sel);
  $dbh->commit;
}


sub get_recent {
  my ($self) = @_;
  my $dbh = $self->{dbh};

  my $sth = $dbh->prepare_cached(<<'EO_SQL');
select path from hist
    where 1=1
    order by mtime desc
    limit 1
EO_SQL

  # $sth->bind_param(1, $base_dir);
  $sth->execute;

  while ( my @row = $sth->fetchrow_array ) {
    $dbh->rollback;
    return $row[0];
  }
}


1;  # ScriptRofi::HistoryDB::Sqlite3



package ScriptRofi::HistoryDB::Dummy;


sub open_or_create {
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
    my ($self, $sel) = @_;
    my $fn = $self->{flag_file};
    open(my $fh, '>', $fn) or die "Could not open file '$fn' $!";
    print $fh $sel;
    close $fh;
}


sub get_recent {
    my $self = shift;
    my $fn = $self->{flag_file};
    open my $fh, '<', $fn or die;
    my $sel = <$fh>;
    close $fh;
    return $sel;
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
  p => 0, s => 0, r => 0, e => 0,
  S => "$ENV{HOME}/local/scripts:$ENV{HOME}/P/v3/bin",
  D => "$ENV{HOME}/.scripts-rofi.sqlite3",
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
  -r : rerun last saved selection
  -e : execute selection
  -S SCRIPT_DIRS      : `:'-separated list
  -D HIST_DB_FILE
  -T XTERM_COMMAND

Exiting.
EO_HELP

  exit 0;
}


my $USE_HISTORY_DB = ! -r NO_HISTORY_DB_FLAG_FILE;

my $history_db = ScriptRofi::HistoryDB::Dummy::open_or_create($opts{D}, NO_HISTORY_DB_FLAG_FILE);
$history_db = ScriptRofi::HistoryDB::Sqlite3::open_or_create($opts{D}) if $USE_HISTORY_DB;
#p $history_db;


# rerun?
if($opts{r}){
  my $saved = $history_db->get_recent;

  if($saved){
    if($opts{p}){
      print "$saved\n";
    }

    if($opts{e}){
      exec($saved);
    }

    exit 0;  # fallback
  }else{
    die 'No saved selection (exiting)';
  }
}

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

if($opts{s}){
  $history_db->update_sel($stdout);
}

if($opts{p}){
  print "$stdout\n";
}

if($opts{e}){
  if($child_exit_status == 10){
    exec($opts{T} . " " . $stdout);
  }else{
    exec($stdout);
  }
}

#EOF.
