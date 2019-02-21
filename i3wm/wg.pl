#!/usr/bin/env perl
use strict;
use warnings;
use feature qw<say>;
use String::ShellQuote;

{
  my @files = split /\n/, qx<find -L ~/P/wg/ -type f -not -path '*/\.git/*'>;
  say scalar @files;
  my $pick = $files[rand @files];
  say $pick;
  system("feh --bg-fill ${pick}");
  my $quote = shell_quote(qx<fortune>);
  system("notify-send ${quote}");
}
#EOF
