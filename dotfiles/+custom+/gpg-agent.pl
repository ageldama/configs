#!/usr/bin/env perl
exit 0 unless -f glob('~/.use-gpg-agent');

use strict;
use warnings;
use Cwd qw(realpath);
use Data::Dumper;


sub grep_file_1st {
  my ($fn, $regex) = @_;

  open(my $fh, '<:encoding(UTF-8)', $fn) or die $!;
  if(grep { /$regex/ } <$fh>){
    close($fh);
    return 1;
  }

  close($fh);
  return 0;
}

sub one_of_executable {
  for my $f (@_) {
    return $f if -x $f;
  }
  die "No suitable executable: " . Dumper(\@_);
}



mkdir "$ENV{HOME}/.gnupg" or warn "mkdir; $!";

my $fn = "$ENV{HOME}/.gnupg/gpg-agent.conf";

exit 0 if -f $fn and grep_file_1st($fn, '^pinentry-program');




my $pinentry = one_of_executable "/usr/local/bin/pinentry-gtk-2", "/usr/bin/pinentry-gtk-2";
# print STDERR $pinentry;

open(my $fh, '>>', $fn) or die "Could not open '$fn': $!";
print $fh "\npinentry-program $pinentry\n";
close($fh);

system("gpgconf --kill gpg-agent");
