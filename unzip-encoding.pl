#!/usr/bin/env perl
use utf8;
use strict;
use warnings;

use Data::Dumper;
use Encode;
use File::stat;
use Getopt::Std;

# CPAN:
use Archive::Zip qw( :ERROR_CODES :CONSTANTS );
use Digest::CRC;


sub crc32_file {
  my $fn = shift;

  my $ctx = Digest::CRC->new( type => 'crc32' );

  open my $fh, '<:raw', $fn or die $!;
  $ctx->addfile(*$fh);
  close $fh;

  return $ctx->digest;
}

sub unzip_with_encoding {
  my $fn = shift;
  my $enc = shift;

  local $Archive::Zip::UNICODE = 0;
  binmode STDOUT, ":utf8";

  my $readzip = Archive::Zip->new();
  unless ( $readzip->read($fn) == AZ_OK ) {
    die 'read error';
  }

  my @members = $readzip->members();
  foreach my $member (@members) {
    my $mem_fn = $member->fileName;
    my $mem_fn_2 = decode('euc-kr', $mem_fn);
    my $size = $member->uncompressedSize();
    my $crc = $member->crc32();
    print 'Extracting: ', $mem_fn_2, "\n";
    $member->extractToFileNamed($mem_fn_2);

    next if $size == 0;

    # check the size and the crc32:
    my $filesize = stat($mem_fn_2)->size;
    $filesize == $size or warn "Size mismatch: extracted($filesize) <=> archived($size)";
    my $crc_actual = crc32_file($mem_fn_2);
    $crc_actual == $crc or warn "CRC32 mismatch";
  }
}


{
  my %opts = (
    'e' => 'euc-kr',
  );
  getopts('e:f:', \%opts);
  die "Specify a zip-file. (-f)" unless exists $opts{f};
  print("Zip-file($opts{f}) with Encoding($opts{e}) ...\n");

  unzip_with_encoding($opts{f}, $opts{e});
}

