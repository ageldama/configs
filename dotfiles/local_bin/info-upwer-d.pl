#!/usr/bin/env perl

use strict;
use warnings;

use Gtk3;


my $stdout = `upower -d`;

# main
Gtk3::init;


my $window = Gtk3::Window->new('toplevel');
$window->signal_connect(destroy => sub { Gtk3::main_quit; });

$window->resize(800, 900);
$window->set_title('upower -d');


my $box = Gtk3::VBox->new;
$window->add($box);

my $quit_btn = Gtk3::Button->new('_Quit');
$quit_btn->signal_connect(clicked => sub { Gtk3::main_quit; });
$box->pack_start($quit_btn, 0, 0, 3);


my $scrolled = Gtk3::ScrolledWindow->new;
$scrolled->set_policy('never', 'automatic');
$box->pack_end($scrolled, 1, 1, 3);

my $buf = Gtk3::TextBuffer->new;
$buf->set_text($stdout);

my $txt = Gtk3::TextView->new;
$txt->set_buffer($buf);
$txt->set_editable(0);
$scrolled->add($txt);


$window->show_all;

Gtk3::main;
