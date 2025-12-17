#!/usr/bin/env perl
exit 0 unless -f glob('~/.use-emacs-yas');

use strict;
use warnings;
use Cwd qw(realpath);

mkdir "$ENV{HOME}/.emacs.d" or warn "mkdir; $!";
symlink realpath('../emacs/snippets'), "$ENV{HOME}/.emacs.d/snippets" or die "symlink: $!";

