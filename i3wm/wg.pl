#!/usr/bin/env perl
use strict;
use warnings;
use feature qw<say>;

#use Glib::Object::Introspection;

{
  my @files = split /\n/, qx<find -L ~/P/wg/ -type f -not -path '*/\.git/*'>;
  say scalar @files;
  my $pick = $files[rand @files];
  say $pick;


  my $color_dark = `gsettings get org.gnome.desktop.interface color-scheme | grep -o \\\\-dark`;
  chomp $color_dark;

  if(defined $color_dark){
    system("pgrep -u $ENV{USER} '^gnome-shell\$' && gsettings set org.gnome.desktop.background picture-uri${color_dark} ${pick} || feh --bg-fill ${pick}");
  }else{
    system("feh --bg-fill ${pick}");
  }

  #
=begin
  Glib::Object::Introspection->setup (
    basename => 'Notify',
    version => '0.7',
    package => 'Notify');
  Notify->init;
  my $s = qx<fortune>;
  my $n = Notify::Notification->new("", $s, "dialog-information");
  $n->show;
=cut
}
#EOF
