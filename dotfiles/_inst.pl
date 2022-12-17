#!/usr/bin/env perl
use strict;
use warnings;
use experimental qw(signatures);
use feature      qw(say);
use Cwd          qw(getcwd abs_path);
use File::Path   qw(make_path);
use File::Basename;
use Path::ExpandTilde;    # no-builtin
use Data::Dumper::OneLine;
use IO::Dir;

# main:
{
    my $inst_or_uninst = shift;    # 'i' or 'u' for installing/uninstalling.
    my $src_dir        = shift;
    my $dst_dir        = expand_tilde shift;

    # dst_Dir
    if ( $inst_or_uninst eq 'i' ) {
        my @created = make_path($dst_dir);
        print "INSTALL: $dst_dir ... mkdir_p: " . Dumper( \@created ) . "\n";
    }
    else {
        print "UNINSTALL: $dst_dir ... (did nothing)\n";
    }

    tie my %dir, 'IO::Dir', $src_dir;
    foreach my $fn ( keys %dir ) {
        next if $fn eq '.' or $fn eq '..';

        # src_fn, dst_fn :
        my $src_fn = "$src_dir/$fn";
        my $dst_fn = "$dst_dir/$fn";

        if ( -l $src_fn ) {
          # pushd
          my $saved_cwd = getcwd;
          chdir dirname($src_fn);

          #
          my $src_fn2 = readlink($src_fn);
          say $src_fn2;

          # popd
          chdir $saved_cwd;
        }

        my $src_fn2 = abs_path($src_fn) or die "$!: $src_fn";
        $src_fn = $src_fn2;

        #say Dumper([$src_fn, $dst_fn]);

        # install -or- uninstall :
        if ( $inst_or_uninst eq 'i' ) {
            print "INSTALL: $src_fn\t-->\t$dst_fn ... ";
            if ( -e $dst_fn ) {
                print "SKIPPING (existing)\n";
            }
            else {
                # TODO: symlink($src_fn, $dst_fn);
                print "SYMLINK\n";
            }
        }
        else {
            my $unlinked = unlink $dst_fn;
            print "UNINSTALL: $dst_fn ... $unlinked\n";
        }
    }
}
