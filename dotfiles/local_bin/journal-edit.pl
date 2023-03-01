#!/usr/bin/perl
use strict;
use warnings;
use utf8;

use DateTime;
use DateTime::Duration;
use Term::ReadLine;
use FindBin qw($Script);
use DDP;

sub show_help {
  print <<EO_HELP;

  h / ? : Help. (This message)

  2006-10-13 : go to exact date.

  +20y / -3m / +5w / +1 : add/subtract durations of years/months/weeks/days.

  . : go to today.

  e : edit current selected date.

  ^D : exit.


EO_HELP
}


my $cur = DateTime->now;
my $term = Term::ReadLine->new($Script);
my $OUT = $term->OUT || \*STDOUT;

show_help;

while (1){
  system(sprintf("ncal -3 -d %d-%02d -H %d-%02d-%02d",
                 $cur->year, $cur->month,
                 $cur->year, $cur->month, $cur->day));
  my $prompt = $cur->ymd . " >>> ";
  my $inp = $term->readline($prompt);

  # ^D
  exit(1) unless defined($inp);

  #
  SWITCH:
  for($inp){
    if($inp eq 'h' || $inp eq '?'){
      show_help;
      last SWITCH;
    }

    if($inp eq 'e'){
      my $editor = $ENV{EDITOR};
      my $ext = $ENV{JOURNAL_EXT} || 'org';
      my $fn = sprintf("%d-%02d%s/%d-%02d%s-%02d%s.%s",
                       $cur->year, $cur->month, $cur->month_abbr,
                       $cur->year, $cur->month, $cur->month_abbr, $cur->day, $cur->day_abbr, $ext);
      my $cmd = $editor . " " . $fn;
      print $cmd . "\n";
      exit system($cmd);
      last SWITCH;
    }

    if($inp eq '.'){
      # today / .
      $cur = DateTime->now;
      last SWITCH;
    }

    if(/^(?<y>\d{4})-(?<m>\d{2})-(?<d>\d{2})$/){
      $cur = DateTime->new(year => $+{y}, month => $+{m}, day => $+{d});
      last SWITCH;
    }

    if(/^(?<n>[+-]\d+)(?<suffix>[ymwd]?)/){
      #print $+{n} . "\n";
      # print $+{suffix} . "\n";

      my $dur;
      if($+{suffix} eq 'y'){
        $dur = DateTime::Duration->new(years => $+{n});
      }elsif($+{suffix} eq 'm'){
        $dur = DateTime::Duration->new(months => $+{n});
      }elsif($+{suffix} eq 'w'){
        $dur = DateTime::Duration->new(weeks => $+{n});
      }else{ # d or (empty)
        $dur = DateTime::Duration->new(days => $+{n});
      }

      $cur += $dur;
      last SWITCH;
    }
  }

  $term->addhistory($inp) if $inp =~ m/\S/;
}
