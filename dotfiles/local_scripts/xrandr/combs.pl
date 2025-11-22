#!/usr/bin/env perl

use strict;
use warnings;

use Getopt::Std;
use Data::Compare;

sub xrandr_connected_displays {
  my @results = ();

  my @lines = split /\n/, qx{xrandr};
  foreach (@lines) {
    push @results, $+{disp} if /^(?<disp>\S+) connected\s+/;
  }

  return @results;
}

sub xrandr_active_displays {
  my @disps = split /\n/, qx{xrandr --listactivemonitors};
  return map /\s+(?<disp>\S+)$/, splice @disps, 1;
}

sub xrandr_onoff_conntected_disps {
  my ( $connecteds, $actives ) = @_;
  my %result = ();

  foreach my $disp (@$connecteds) {
    $result{$disp} = 0;
  }

  foreach my $active (@$actives) {
    $result{$active} = 1;
  }

  return \%result;
}

sub dec2bin {
  my $str = unpack( "B32", pack( "N", shift ) );
  $str =~ s/^0+(?=\d)//;    # otherwise you'll get leading zeros
  return $str;
}

sub bin2dec {
  return unpack( "N", pack( "B32", substr( "0" x 32 . shift, -32 ) ) );
}

sub leftpad {
  my ( $maxlen, $text, $pad ) = @_;
  my $npad = $maxlen - length $text;
  return $text if $npad < 1;
  return $pad x $npad . $text;
}

sub onoff_combinations {
  my ($arr) = shift;
  my $arr_len = scalar @$arr;

  my @results = ();

  for ( my $i = 1 ; ; $i++ ) {
    my $bin = dec2bin $i;
    last if length $bin > $arr_len;

    my $padded_bin = leftpad $arr_len, $bin, '0';

    my %onoffs = ();
    for ( my $idx = 0 ; $idx < $arr_len ; $idx++ ) {
      my $onoff = substr( $padded_bin, $idx, 1 ) + 0;
      $onoffs{ $arr->[$idx] } = $onoff;
    }
    push @results, \%onoffs;
  }

  return @results;
}

sub find_onoff_disp {
  my ( $disp_combs, $onoff_disp ) = @_;
  my $found = undef;

  for ( my $idx = 0 ; $idx < scalar @$disp_combs ; $idx++ ) {
    my $disp_comb = $disp_combs->[$idx];
    return $idx if Compare( $disp_comb, $onoff_disp );
  }

  return $found;
}

sub build_xrandr_cmd {
  my ($onoff) = shift;
  my $cmd = 'xrandr ';

  foreach my $disp ( keys %$onoff ) {
    my $onoff = $onoff->{$disp};
    $cmd .= " --output $disp ";
    if ($onoff) {
      $cmd .= '--auto';
    }
    else {
      $cmd .= '--off';
    }
  }

  return $cmd;
}

# --- main :
{
  # 연결된 모든 display 이름: ("HDMI-1", "eDP-1")
  my @disps = xrandr_connected_displays;

  # 모든 on/off 조합:
  # ({"HDMI-1"=>1, "eDPI-1"=>0}, ...)
  my @onoffs = onoff_combinations \@disps;

  # 현재 켜진 display 배열: ("HDMI-1")
  my @active_disps = xrandr_active_displays;

  # 연결된 display의 모든 이름에 on/off 플래그 설정:
  # {"HDMI-1"=>1, "eDP-1"=>0}
  my $onoff_disp = xrandr_onoff_conntected_disps( \@disps, \@active_disps );

  # on/off-조합에서 현재 인덱스, 다음 조합의 인덱스 구하기.
  my $cur_idx = find_onoff_disp( \@onoffs, $onoff_disp );

  my $next_idx = $cur_idx + 1;
  $next_idx = 0 if $next_idx >= scalar @onoffs;

  my $next_comb = $onoffs[$next_idx];

  # Getopt:
  my %opts = ( i => 0, l => 0 );
  getopts( 'il', \%opts );

  if ( $opts{i} ) {
    my $cmd = build_xrandr_cmd($next_comb);
    system($cmd);
    print $cmd . "\n";
  }
  elsif ( $opts{l} ) {

    # print the next candidate first:
    print build_xrandr_cmd($next_comb), "\n";

    # print the rests:
    for ( my $idx = 0 ; $idx < scalar @onoffs ; $idx++ ) {
      next if $idx == $next_idx;

      # p $onoffs[$idx];
      print build_xrandr_cmd( $onoffs[$idx] ), "\n";
    }
  }
  else {
    die "Usage: -i == run xrandr immed. / -l == list all\n";
  }
}

__DATA__

eDP-1 connected (normal left inverted right x axis y axis)

HDMI-1 connected primary 1920x1080+0+0 (normal left inverted right x axis y axis) 798mm x 334mm
