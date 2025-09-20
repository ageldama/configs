#!/usr/bin/env perl

use strict;
use warnings;

my $stdout = qx<mixer vol.mute=tog>;
qx<notify-send "$stdout">;
