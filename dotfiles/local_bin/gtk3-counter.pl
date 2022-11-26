#!/usr/bin/env perl
use strict;
use warnings;
use boolean;
use Gtk3;


sub quit_with_confirm {
    my $parent = shift;
    if(dlg_yes_no($parent, 'Really quit?')){
        Gtk3::main_quit;
    }
}

sub relabel_btn_count {
    my ($btn, $cnt) = @_;
    my $lbl = $btn->get_child;
    $lbl->set_markup("<span size='128000' foreground='green'><tt>$cnt</tt></span>");
}

sub config_btn_count {
    my $btn = shift;
    my $lbl = $btn->get_child;
    # NOTE does nothing
}

sub dlg_yes_no {
    my ($parent, $msg) = @_;
    my $dialog = Gtk3::MessageDialog->new(
        $parent,
        [qw( modal destroy-with-parent )],
        'question',
        'yes_no',
        $msg);
    my $ans = $dialog->run;
    $dialog->destroy;
    return $ans eq 'yes';
}

# main
Gtk3::init;

my $window = Gtk3::Window->new('toplevel');
$window->signal_connect(destroy => sub { Gtk3::main_quit; });

my $vbox = Gtk3::Box->new('vertical', 2);
$window->add($vbox);

my $button_box = Gtk3::Box->new('horizontal', 2);
$button_box->set_halign('center');

my $count = 0;
my $btn_count = Gtk3::Button->new_with_label('foobar?');
#config_btn_count($btn_count);
$vbox->pack_start($btn_count, true, true, 3);
$btn_count->signal_connect(
    clicked => sub {
        $count ++;
        relabel_btn_count($btn_count, $count);
    });
relabel_btn_count($btn_count, $count);

my $btn_decr = Gtk3::Button->new('--x');
$btn_decr->signal_connect(
    clicked => sub {
        if(dlg_yes_no($window, 'Decrease by 1?')){
            $count --;
            relabel_btn_count($btn_count, $count);
        }
    });
$button_box->pack_start($btn_decr, false, false, 3);

my $btn_reset = Gtk3::Button->new('x<-0');
$btn_reset->signal_connect(
    clicked => sub {
        if(dlg_yes_no($window, 'Reset?')){
            $count = 0;
            relabel_btn_count($btn_count, $count);
        }
    });
$button_box->pack_start($btn_reset, false, false, 3);

my $btn_quit = Gtk3::Button->new('Quit');
$btn_quit->signal_connect(clicked => sub { quit_with_confirm($window);});
$button_box->pack_start($btn_quit, false, false, 3);

$vbox->pack_start($button_box, false, false, 3);


$window->show_all;

Gtk3::main;

