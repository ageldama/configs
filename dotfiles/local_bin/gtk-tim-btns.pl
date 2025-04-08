#!/usr/bin/env perl

use utf8;
use strict;
use warnings;

use FindBin qw($RealScript);
use Gtk3;
use File::Find;

use DDP;




use constant CONFIG_FILE =>  $ENV{HOME} . "/.my-gtk-tim-btns.pl";

use constant SCAN_DIRS => [
  [$ENV{HOME} . '/local/scripts', 'blue', 'lightgrey', 'normal 18px serif'],
  [$ENV{HOME} . '/local/bin', 'darkgreen', 'lightgrey', 'normal 18px serif'],
];


my $cmds = do CONFIG_FILE;

if(!defined $cmds){
    warn "No config file: " . CONFIG_FILE;
    $cmds = [
      {
        name => 'reboot',
        cmd => 'sh -c "yesno.tcl \'reboot?\' && sudo reboot"',
        fg => 'yellow',
        bg => 'red',
      },

      {
        name => 'poweroff',
        cmd => 'sh -c "yesno.tcl \'poweroff?\' && sudo poweroff"',
        fg => 'yellow',
        bg => 'red',
      },
    ];
}


sub find_and_add {
  my ($dir, $arr, $fg, $bg, $font) = @_;

  find(
      {
          wanted => sub {
              my $fn = $File::Find::name;
              return if -d $fn;

              print "Scanned: " . $fn . "\n";

              my $name = substr($fn, (length $dir) + 1);

              push @$arr, {
                name => $name,
                cmd => $fn,
                fg => $fg,
                bg => $bg,
                font => $font,
              };
          },
          follow => 1,
      },
      $dir
     );
}


foreach my $scan_dir (@{+SCAN_DIRS}) {
  my ($dir, $fg, $bg, $font) = @$scan_dir;
  find_and_add($dir, $cmds, $fg, $bg, $font);
}


# main
Gtk3::init;


my $window = Gtk3::Window->new('toplevel');
$window->stick;
$window->signal_connect(destroy => sub { Gtk3::main_quit; });
$window->resize(800, 900);
$window->maximize;
$window->set_title($RealScript);



my $scrolled = Gtk3::ScrolledWindow->new;
$scrolled->set_policy('never', 'automatic');
$window->add($scrolled);


my $box = Gtk3::FlowBox->new;
$box->set_margin_top(30);
$box->set_margin_bottom(30);
$box->set_margin_left(30);
$box->set_margin_right(30);
$box->set_homogeneous(0);
$box->set_row_spacing(20);
$box->set_column_spacing(20);
$box->set_valign('start');
$box->set_max_children_per_line(30);
$scrolled->add($box);




for my $row (@$cmds) {
    my $name =  exists $row->{name} ? $row->{name} : $row->{cmd};
    my $cmd = $row->{cmd};
    my $font = exists $row->{font} ? $row->{font} : 'normal 18px serif';
    my $fg = exists $row->{fg} ? $row->{fg} : 'black';
    my $bg = exists $row->{bg} ? $row->{bg} : 'lightgrey';

    my $btn = Gtk3::Button->new($name);
    $btn->signal_connect(
        clicked => sub {
            print "clicked: $cmd\n";
            system($cmd . ' &');
        });

    $box->add($btn);

    my $css_provider = Gtk3::CssProvider->new;
    $css_provider->load_from_data("* {font: $font; background-image:none; background-color:$bg; color: $fg;}");
    $btn->get_style_context->add_provider($css_provider, -1);
}

$window->show_all;


Gtk3::main;

