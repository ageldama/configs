#!/usr/bin/env perl

use strict;
use warnings;

my $stdout = qx<mixer vol=-3%>;
qx<notify-send "$stdout">;
