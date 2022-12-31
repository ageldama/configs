#!/usr/bin/env perl
use strict;
use warnings;
use feature qw(say);
use Data::Dumper;


sub rand_color {
    return sprintf("#%02x%02x%02x", int(rand(256)), int(rand(256)), int(rand(256)));
}

sub rand_ncolors {
    return 1 + int(rand(10));
}

sub save_fehbg {
	my $cmd = shift;

	open(my $fh, ">", "$ENV{HOME}/.fehbg") || die;
	print $fh "#!/bin/sh\n";
	print $fh "$cmd\n";
	close($fh);
}

sub gen_cmd_solid {
	my $c = rand_color;
	my $cmd = sprintf("hsetroot -solid '%s'", $c);
	return $cmd;
}

sub gen_cmd_grads {
	my @colors = map { sprintf("-add '%s'", rand_color()); } (1 .. rand_ncolors);
	my $gradient_colors = join " ", @colors;
	my $cmd = sprintf("hsetroot %s -gradient %d", $gradient_colors, int(rand(360)));
	return $cmd;
}

# main:
my $n = 0+int(rand(3));
my $cmd = '';

if($n == 0){
  system('wg.pl');
  exit 0;
}elsif($n % 2){
	$cmd = gen_cmd_solid;
}else{
	$cmd = gen_cmd_grads;
}

system($cmd);
# system(sprintf("notify-send -u low '%s'", $c));
save_fehbg($cmd);


#EOF.
