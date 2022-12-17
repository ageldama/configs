#!/usr/bin/env perl
use strict;
use warnings;

use experimental qw(signatures);
use feature qw(say);
use Cwd 'abs_path';
use File::Glob ':bsd_glob';


sub expand_tilde ($path) {
  return bsd_glob($path, GLOB_TILDE | GLOB_ERR);
}

# main:
my $inst_or_uninst = shift;  # 'i' or 'u' for installing/uninstalling.
my $src_dir = shift;
my $dst_dir = expand_tilde shift;

# TODO
