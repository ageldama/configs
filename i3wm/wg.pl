#!/usr/bin/env perl
use strict;
use warnings;
use feature qw<say>;

use Glib::Object::Introspection;

{
  my @files = split /\n/, qx<find -L ~/P/wg/ -type f -not -path '*/\.git/*'>;
  say scalar @files;
  my $pick = $files[rand @files];
  say $pick;
  system("feh --bg-fill ${pick}");
  #
  Glib::Object::Introspection->setup (
    basename => 'Notify',
    version => '0.7',
    package => 'Notify');
  Notify->init;
  my $s = qx<fortune>;
  my $n = Notify::Notification->new("", $s, "dialog-information");
  $n->show;
}
#EOF
