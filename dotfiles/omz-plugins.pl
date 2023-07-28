#!/usr/bin/env perl
use strict;
use warnings;
use Carp;
use File::Inplace;
use Set::Scalar;
use DDP;


my @desired_plugins = qw(fzf zoxide systemd docker docker-compose);
my $desireds = Set::Scalar->new(@desired_plugins);

{
  my $i_or_u = shift;    # 'i' or 'u' for installing/uninstalling.
  croak 'Specify: i || u.' unless defined($i_or_u) and ($i_or_u eq 'i' or $i_or_u eq 'u');

  #
  my $editor = new File::Inplace(
    file => "$ENV{HOME}/.zshrc",
    suffix => '.old',
   );

  while (my ($line) = $editor->next_line) {
    if($line =~ m/^plugins=\((?<plugins>.*)\)/){
      my @plugins = split / /, $+{plugins};
      my $cur = Set::Scalar->new(@plugins);

      if($i_or_u eq 'i'){
        $cur = $desireds + $cur;
      }else{
        $cur = $cur - $desireds;
      }

      my $newl = join ' ', $cur->elements;
      p $newl;
      $editor->replace_line("plugins=($newl)");
    }
  }

  $editor->commit;

}

