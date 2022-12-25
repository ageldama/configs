#!/usr/bin/env perl
use strict;
use warnings;

package X11::Geometry;

use List::Util qw( min first );
use Math::Complex;
use DDP;

sub new {
    my %opt = @_;
    return bless( \%opt, 'X11::Geometry' );
}

sub from_geom_str {
    my ($geom_str) = @_;
    $geom_str =~ m/^(?<w>\d+)x(?<h>\d+)\+(?<x>\d+)\+(?<y>\d+)$/
      or warn "No matches: $geom_str";
    return new(
        w => $+{w},
        h => $+{h},
        x => $+{x},
        y => $+{y},
    );
}

sub distance {
    my ( $a, $b ) = @_;
    return sqrt( ( $b->{x} - $a->{x} )**2 + ( $b->{y} - $a->{y} )**2 );
}

sub index_of_min_distance {
    my $self  = shift;
    my @geoms = @_;

    return undef if scalar @geoms == 0;

    # calc. distances
    my @distances = ();
    foreach my $g (@geoms) {
        my $dist = distance( $self, $g );
        push @distances, $dist;
    }

    # index of min. distance?
    my $mn    = min @distances;
    my $index = first { $distances[$_] == $mn } 0 .. $#distances;
    return $index;
}

sub offset_from {
    my ( $self, $other ) = @_;
    return {
        x => $self->{x} - $other->{x},
        y => $self->{y} - $other->{y},
    };
}

sub new_move_by {
    my ( $self, $x_delta, $y_delta ) = @_;
    return X11::Geometry::new(
        w => $self->{w},
        h => $self->{h},
        x => $self->{x} + $x_delta,
        y => $self->{y} + $y_delta,
    );
}

1;

#
package Shell::IceSh;

sub randr_geoms {
    my @geoms = ();

    foreach my $l (qx/icesh randr/) {
        chomp $l;
        if ( $l =~ m/(?<gs>\d+x\d+\+\d+\+\d+)/ ) {
            my $m = $+{gs};
            next if $m eq '0x0+0+0';
            push @geoms, X11::Geometry::from_geom_str($m);
        }
    }

    return @geoms;
}

sub focus_geom {
    my $geom_str = qx/icesh -w focus getGeometry/;
    return X11::Geometry::from_geom_str($geom_str);
}

sub move_focused {
    my ( $x, $y ) = @_;
    qx(icesh -w focus move $x $y);
}

1;

#
package main;

use DDP;

sub circle_idx {
    my ( $cur_idx, $len ) = @_;
    my $new_idx = $cur_idx + 1;
    if ( $len == $new_idx ) {
        return 0;
    }
    return $new_idx;
}

my $cur_win = Shell::IceSh::focus_geom;
my @randrs  = Shell::IceSh::randr_geoms;

my $cur_idx    = $cur_win->index_of_min_distance(@randrs);
my $next_idx   = circle_idx( $cur_idx, scalar @randrs );
my $cur_randr  = $randrs[$cur_idx];
my $next_randr = $randrs[$next_idx];

my $offset_xy = $cur_win->offset_from($cur_randr);
my $new_geom  = $next_randr->new_move_by( $offset_xy->{x}, $offset_xy->{y} );
Shell::IceSh::move_focused( $new_geom->{x}, $new_geom->{y} );

#EOF.
