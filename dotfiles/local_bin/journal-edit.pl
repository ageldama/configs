#!/usr/bin/perl
use strict;
use warnings;
use utf8;

use DateTime;
use DateTime::Duration;
use Term::ReadLine;
use FindBin qw($Script);
use DDP;
use Calendar::Any::Util::Calendar qw(calendar);
use Text::Table;
use Term::ANSIColor;


sub highlight_day {
    my ($cal, $day, $colorspec) = @_;
    my $replacement = colored($day, $colorspec || 'white on_green');
    $cal =~ s/\b$day\b/$replacement/g;
    return $cal;
}


sub cal3 {
    my ($yr, $mon, $day) = @_;

    my $today = DateTime->new(
        year       => $yr,
        month      => $mon,
        day        => $day,
        hour       => 10,
        minute     => 13,
        second     => 42,
    );

    my $first_day = $today->clone;
    $first_day->set(day => 1);

    my $prev_mon = $first_day - DateTime::Duration->new(months => 1);
    my $next_mon = $first_day + DateTime::Duration->new(months => 1);


    my $tb = Text::Table->new(
        "", '', "", '', "",
    );

    $tb->load([
        calendar($prev_mon->month, $prev_mon->year),
        ' ',
        highlight_day(calendar($today->month, $today->year), $today->day),
        ' ',
        calendar($next_mon->month, $next_mon->year),
    ]);

    return $tb;
}


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


sub create_memo_file {
  my ($filename, $date) = @_;

	open(my $fh, '>', $filename) or die $!;
	print $fh "#+TITLE: $date\n";
	print $fh "#+TAGS[]\n";
	print $fh "\n\n\n";
	close($fh);
}


my $cur = DateTime->now;
my $term = Term::ReadLine->new($Script);
my $OUT = $term->OUT || \*STDOUT;

show_help;

while (1){
  print "\n" . cal3($cur->year, $cur->month, $cur->day);

  my $prompt = colored($cur->ymd, 'underline') . ' > ';
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
			create_memo_file($fn,
				sprintf("%d-%02d-%02d", $cur->year, $cur->month, $cur->day)) unless -f $fn;
      my $cmd = $editor . " " . $fn;
      print $cmd . "\n";
      system($cmd);
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
