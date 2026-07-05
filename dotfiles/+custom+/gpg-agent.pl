#!/usr/bin/env perl
exit 0 unless -f glob('~/.use-gpg-agent');

use strict;
use warnings;
use Cwd qw(realpath);

mkdir "$ENV{HOME}/.gnupg" or warn "mkdir; $!";
#symlink realpath('../emacs/snippets'), "$ENV{HOME}/.emacs.d/snippets" or die "symlink: $!";

