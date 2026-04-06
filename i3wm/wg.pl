#!/usr/bin/env perl
use strict;
use warnings;
use feature qw<say>;
use Cwd     qw(abs_path);

#use Glib::Object::Introspection;

{
    my $pick = shift;

    if ( !defined($pick) ) {
        my @files = split /\n/,
          qx<find -L ~/P/wg/ -type f -not -path '*/\.git/*'>;
        say scalar @files;
        $pick = $files[ rand @files ] or die;
        $pick = abs_path $pick;
        say $pick;
    }
    else {
        say 1;
        $pick = abs_path $pick;
        say $pick;
    }

    my $color_dark =
`gsettings get org.gnome.desktop.interface color-scheme | grep -o \\\\-dark`
      || undef;

   my $feh_opts = '--bg-fill';

   if ( $pick =~ qr{/tile} ) {
	  $feh_opts = '--bg-tile';
   }

    if ( defined $color_dark ) {
        chomp $color_dark;
        system(
"pgrep -u $ENV{USER} '^gnome-shell\$' && gsettings set org.gnome.desktop.background picture-uri${color_dark} \'${pick}\' || feh ${feh_opts} \'${pick}\'"
        );
    }
    else {
        system("feh ${feh_opts} \'${pick}\'");
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
