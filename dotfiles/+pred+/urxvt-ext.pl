#!/usr/bin/env perl

exit 1 unless -r "$ENV{HOME}/.use-urxvt";

if(-r '/etc/os-release'){
  open my $fh, '<', '/etc/os-release' or die;
  while(<$fh>){
    # opensuse은 패키지 있어서 생략하기:
    exit 1 if m/opensuse/;
  }
  close $fh;
}

# debian은 아마 내 dotfiles해야 할듯:
exit 0;
