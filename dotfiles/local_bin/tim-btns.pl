#!/usr/bin/env perl

use utf8;
use strict;
use warnings;

use Tk;
use Tk::Pane;

use DDP;

use constant CONFIG_FILE =>  $ENV{HOME} . "/.my-tim-btns.pl";


my $cmds = do CONFIG_FILE;

if(!defined $cmds){
    warn "No config file: " . CONFIG_FILE;
    $cmds = [
        {
            name => 'reboot',
            cmd => 'sh -c "zenity --question --text=\'reboot?\' && sudo reboot"',
            fg => 'yellow',
            bg => 'red',        
        },

        {
            name => 'poweroff',
            cmd => 'sh -c "zenity --question --text=\'poweroff?\' && sudo poweroff"',
            fg => 'yellow',
            bg => 'red',
        },    
        ];
}


my $top = MainWindow->new;

=begin
$top->geometry(($top->maxsize())[0] .'x'.
                ($top->maxsize())[1]);
=cut

$top->geometry('800x' .
                ($top->maxsize())[1]);


my $frame = $top->Scrolled('Pane', -scrollbars => 'e')
    ->pack(-side => 'top', -expand => 1, -fill => 'both');

for my $row (@$cmds) {
    my $b = $frame->Button(
        -text => (exists $row->{name} ? $row->{name} : $row->{cmd}),
        -padx => 10,
        -pady => 8,
        -font => (exists $row->{font} ? $row->{font} : ''),
        -fg => (exists $row->{fg} ? $row->{fg} : 'black'),
        -bg => (exists $row->{bg} ? $row->{bg} : 'grey'),
        -command => [
             sub {
                 my ($cmd) = @_;
                 print $cmd . "\n";
                 system($cmd . ' &');
             }, $row->{cmd}]);

    $b->pack(
        -side => 'top', -fill => 'both', -expand => 1,
        -pady => 20,
        );
}




#
MainLoop;

