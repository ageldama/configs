#!/usr/bin/env perl
use strict;
use warnings;
use Data::Dumper;
use Getopt::Std;
use IO::File;
use File::Glob   qw(bsd_glob);
use Cwd          qw(getcwd abs_path);
use File::Path   qw(make_path);
use File::Basename;
use IO::Dir;



sub do_inst_or_uninst {
  local $Data::Dumper::Indent = 0;
  local $Data::Dumper::Terse = 1;

  my $inst_or_uninst = shift; # 'i' or 'u' for installing/uninstalling.
  my $src_dir        = shift;
  my $dst_dir        = bsd_glob shift;

  # dst_Dir
  if ( $inst_or_uninst eq 'i' ) {
    my @created = make_path($dst_dir);
    print "|- MKDIR: $dst_dir : " . Dumper( \@created ) . "\n";
  } else {
    # print "UNINSTALL: $dst_dir ... (did nothing)\n";
  }

  tie my %dir, 'IO::Dir', $src_dir;
  foreach my $fn ( keys %dir ) {
    next if $fn eq '.' or $fn eq '..';

    # src_fn, dst_fn :
    my $src_fn = "$src_dir/$fn";
    my $dst_fn = "$dst_dir/$fn";

    # readlink (...for real / as realink(1)) :
    $src_fn = abs_path($src_fn);

    #say Dumper([$src_fn, $dst_fn]);

    # install -or- uninstall :
    if ( $inst_or_uninst eq 'i' ) {
      print "|- INSTALL:\t$src_fn\n\t-->\t$dst_fn\n";
      if ( -e $dst_fn ) {
        print "\t\t* ALREADY EXISTING *\n";
      } else {
        symlink( $src_fn, $dst_fn ) or warn "$! : $src_fn => $dst_fn";
        print "\t\t* SYMLINKED *\n";
      }
    } else {
      my $unlinked = unlink $dst_fn;
      print "|- UNINSTALL:\t$dst_fn\n\t\t* UNLINKED($unlinked) *\n";
    }
  }
}



# --- main:
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
          print "------------------- [ *CUSTOM* ] $script $inst_or_uninst\n";
          system("$script $inst_or_uninst");
          print "\n\n";
          next;
        }

        # otherwise: SRC    DEST   PRED
        my ($dot_dir, $dst_dir, $pred) = split /\s+/, $line;

        my $ok_to_go = 0;

        if ($pred =~ /^F:(.*)/) {
          my $use_file = $1;
          $ok_to_go = 1 if -r bsd_glob($use_file);
        } else {
          qx/$pred/;
          $ok_to_go = $? == 0;
        }

        print "------------------- [ $dot_dir ]\n";
        print "|- PRED:\t$pred\n";
        print "|- DEST:\t$dst_dir\n";
        print "|- ", ($ok_to_go ? "APPLYING ..." : "SKIPPING."), "\n";
        if ($ok_to_go) {
          do_inst_or_uninst($inst_or_uninst, $dot_dir, $dst_dir);
        }
        print "\n\n";
    }

    close $fh;
}

