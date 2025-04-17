#!/usr/bin/env perl

use strict;
use warnings;

# xset : blank / dpms
qx<xset s off>;
qx<xset s noblank>;
qx<xset -dpms>;

# xautolock
qx<xautolock -exit>;

# xscreensaver
qx<xscreensaver-command -exit>;

# .
print STDERR "DONE!\n";
exit 0;
