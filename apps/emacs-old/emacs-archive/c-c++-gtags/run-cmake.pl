#!/usr/bin/env perl
use strict;
use warnings;
use Cwd qw(abs_path);
use File::Basename;

my $dirname = basename(dirname(abs_path($0)));
print qx(cmake -H. -B\${1:-../build-${dirname}} -GNinja -DCMAKE_INSTALL_PREFIX=\${2:-../install-${dirname}} -DCMAKE_BUILD_TYPE=Debug  -DCMAKE_EXPORT_COMPILE_COMMANDS=on);


