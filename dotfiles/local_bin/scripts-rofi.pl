#!/usr/bin/env perl

use strict;
use warnings;

{

    package ScriptsRofi::Consts;

    use strict;
    use warnings;

    use constant {
        ROFI_EXITCODE_NORMAL => 0,
        ROFI_EXITCODE_ALT_1  => 10,

        SELECTION_UNDEF   => -1,
        SELECTION_NORMAL  =>  0,
        SELECTION_IN_TERM =>  1,
    };

    sub selection_to_str {
        my $sel_type = shift;
        if ( $sel_type == SELECTION_UNDEF ) {
            return '???Undefined???';
        }
        elsif ( $sel_type == SELECTION_NORMAL ) {
            return 'Normal';
        }
        elsif ( $sel_type == SELECTION_IN_TERM ) {
            return 'In-terminal';
        }
        else {
            die "Unsupported: $sel_type";
        }
    }
}
1;    # ScriptsRofi::Consts;

package ScriptsRofi::HistoryDB::Storable;
{
    use strict;
    use warnings;

    use Storable qw( retrieve store);
    use Carp     qw(carp confess croak);

    sub new {
        my $class   = shift;
        my $db_path = shift;

        return bless {
            scripts => {},
            db_path => $db_path,
        }, $class;
    }

    sub update_paths {
        my ( $self, $scripts ) = @_;
        my $db_path = $self->{db_path};

        if ( -r $db_path ) {
            $self->{scripts} = retrieve( $self->{db_path} )
              or carp "Storable retrieve failed: $!";
        }
        my $h = $self->{scripts};

        foreach my $s (@$scripts) {
            if ( !exists( $h->{$s} ) ) {

                # print "UPD: $s\n";
                $h->{$s} = { last => time, };
            }
        }

        store( $h, $db_path ) or croak "Storable store failed: $!";
    }

    sub list_sorted {
        my ($self) = @_;

        $self->{scripts} = retrieve( $self->{db_path} )
          or croak "Storable retrieve failed: $!";
        my $h = $self->{scripts};

        my @sorted_keys =
          reverse( sort { $h->{$a}->{last} cmp $h->{$b}->{last} } keys %$h );

        return [@sorted_keys];
    }

    sub update_sel {
        my ( $self, $sel, $sel_type ) = @_;

        my $db_path = $self->{db_path};
        my $h       = $self->{scripts};

        $h->{$sel}->{last} = time;

        my $sel_type_k = "sel_" . $sel_type;
        $h->{$sel}->{$sel_type_k}++;

        store( $h, $db_path ) or croak "Storable store failed: $!";
    }

    sub most_sel_type {
        my ( $self, $sel ) = @_;

        my $db_path = $self->{db_path};
        my $h       = $self->{scripts};

        if ( exists( $h->{$sel} ) ) {
            my %sels = ();
            foreach my $k ( keys %{ $h->{$sel} } ) {
                next unless $k =~ /^sel_(?<sel_type>\d+)/;

                # print "$k $+{sel_type} \n";
                $sels{ $+{sel_type} } = $h->{$sel}->{"sel_$+{sel_type}"};
            }
            if ( scalar keys %sels > 0 ) {
                my @ranked =
                  reverse( sort { $sels{$a} cmp $sels{$b} } keys %sels );
                return $ranked[0];
            }
        }

        return ScriptsRofi::Consts::SELECTION_UNDEF;    # fallback
    }
}
1;    # ScriptsRofi::HistoryDB::Storable

package ScriptsRofi::HistoryDB::Dummy;
{
    use strict;
    use warnings;

    sub new {
        my ( $class, $db_path, $flag_file ) = @_;

        return bless {
            scripts   => [],
            flag_file => $flag_file,
        }, $class;
    }

    sub update_paths {
        my ( $self, $scripts ) = @_;
        $self->{scripts} = $scripts;
    }

    sub list_sorted {
        my ($self) = @_;
        return $self->{scripts};
    }

    sub update_sel {
    }

    sub most_sel_type {
        my ( $self, $sel ) = @_;
        return ScriptsRofi::Consts::SELECTION_UNDEF;
    }
}
1;    # ScriptsRofi::HistoryDB::Dummy;

package ScriptsRofi::Dlg::YesNo;
{
    use strict;
    use warnings;

    use builtin qw(true false);

    use Carp;
    use IPC::Open2 qw(open2);

    sub ask_yes_or_no {
        my ( $class, $q, $lbl_yes, $lbl_no ) = @_;

        $lbl_yes ||= 'Yes';
        $lbl_no  ||= 'No';

        my $pid = open2(
            my $stdout,
            my $stdin,
"rofi -theme-str 'window {width: 400px; height: 150px;}' -dmenu -p '$q' -sep '\\0' -format i"
        ) or confess;

        print $stdin "$lbl_yes\0";
        print $stdin "$lbl_no\0";
        close($stdin);

        my $stdout_ = do { local ($/); <$stdout> };
        close($stdout);
        chomp $stdout_;

        waitpid( $pid, 0 );
        my $exit_code = $? >> 8;

        # print STDERR "exit_code: $exit_code\n";
        # print STDERR "output: [$stdout_]\n";

        return ($exit_code == 0, $stdout_);
    }
}
1;    # ScriptsRofi::Dlg::YesNo;

package main;

use strict;
use warnings;
use feature     qw(say);
use File::Find  qw(find);
use IPC::Open2  qw(open2);
use Getopt::Std qw(getopts);
use Data::Dumper;

our $VERSION = '0.0.1';

use constant NO_HISTORY_DB_FLAG_FILE => "$ENV{HOME}/.no-db-scripts-rofi";

my %opts = (
    p => 0,
    s => 0,
    e => 0,
    S => "$ENV{HOME}/local/scripts:$ENV{HOME}/local/bin:$ENV{HOME}/.screenlayout:$ENV{HOME}/P/v3/bin",
    D => "$ENV{HOME}/.scripts-rofi.storable",
    T => "x-terminal-emulator -e",
    P => 0,
);
getopts( 'psrePS:D:T:', \%opts );

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
  -P : Dump stored history/freqs and exit

Exiting.
EO_HELP

    exit 0;
}

my $USE_HISTORY_DB = !-r NO_HISTORY_DB_FLAG_FILE;

my $history_db =
  ScriptsRofi::HistoryDB::Dummy->new( $opts{D}, NO_HISTORY_DB_FLAG_FILE );
$history_db = ScriptsRofi::HistoryDB::Storable->new( $opts{D} )
  if $USE_HISTORY_DB;

if($opts{P}){
  my $scripts = $history_db->list_sorted;
  foreach my $script (@$scripts) {
    printf "%s\t%s\n", $script, $history_db->most_sel_type($script);
  }
  exit 0;
}

#p $history_db;

# main
my @scripts = ();

foreach my $dir ( split /:/, $opts{S} ) {
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

$history_db->update_paths( \@scripts );

my $scripts_sorted = $history_db->list_sorted;

my $pid = open2(
    my $chld_out,
    my $chld_in,
'rofi -dmenu -p "Select a script to run (Shift-Enter == run-in-terminal)" -kb-accept-alt "" -kb-custom-1 "Shift+Return" '
) or die;

# say "rofi-pid: $pid";

print $chld_in "$_\n" foreach @$scripts_sorted;

close($chld_in) or die;

# reap zombie and retrieve exit status
waitpid( $pid, 0 );
my $child_exit_status = $? >> 8;

# say "rofi-exitcode: $child_exit_status";

if (   $child_exit_status != ScriptsRofi::Consts::ROFI_EXITCODE_NORMAL
    && $child_exit_status != ScriptsRofi::Consts::ROFI_EXITCODE_ALT_1 )
{
    close($chld_out);
    die 'bye: cancelled';
}

#
my $stdout = <$chld_out>;

# print "[$stdout]\n";
chomp $stdout;

close($chld_out) or die;

my $sel_type = ScriptsRofi::Consts::SELECTION_NORMAL;
if ( $child_exit_status == ScriptsRofi::Consts::ROFI_EXITCODE_ALT_1 ) {
    $sel_type = ScriptsRofi::Consts::SELECTION_IN_TERM;
}

my $most_sel_type = $history_db->most_sel_type($stdout);
# printf STDERR "mostly[%d] sel[%d]\n", $most_sel_type, $sel_type;
if (   $most_sel_type != ScriptsRofi::Consts::SELECTION_UNDEF
    && $most_sel_type != $sel_type )
{
    my ($answered, $most_or_sel_idx) = ScriptsRofi::Dlg::YesNo->ask_yes_or_no(
        'Different selection, use ...',
        ScriptsRofi::Consts::selection_to_str($most_sel_type),
        ScriptsRofi::Consts::selection_to_str($sel_type)
       );
    # say "ANS_MODified:", $answered;
    if ($answered) {
        print STDERR "CORRECTING: $sel_type => $most_sel_type\n";
        $sel_type = ($most_sel_type, $sel_type)[$most_or_sel_idx];
    }
}

if ( $opts{s} ) {
    $history_db->update_sel( $stdout, $sel_type );
}

if ( $opts{p} ) {
    print "$stdout\n";
    if ( $sel_type == ScriptsRofi::Consts::SELECTION_IN_TERM ) {
        print "# with terminal: '$opts{T}'\n";
    }
}

if ( $opts{e} ) {
    if ( $sel_type == ScriptsRofi::Consts::SELECTION_IN_TERM ) {
        exec( $opts{T} . " " . $stdout );
    }
    else {
        exec($stdout);
    }
}

#EOF.
