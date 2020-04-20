#!/usr/bin/perl 
use strict;
use warnings;
use Getopt::Long;
use IPC::Open2;
use Time::Piece;

sub parseTime($){
  my $e = shift;
  if ($e =~ /^(\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}),(\d{3})/) {
    my ($ts, $ms) = ($1, $2);
    $ms=$ms=~s/^0*(?=\d+)//gr;
    return Time::Piece->strptime($ts, "%Y-%m-%d %H:%M:%S")->strftime("%s")*1000+$ms;
  } else {
    return 0;
  }
}

while(<>){
  if (/^(\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2},\d{3})/) {
    my $eventTime = $1;
    my $tsMs = parseTime($eventTime);
    my ($tsSecPart, $tsMsPart) = ($tsMs/1000, $tsMs%1000);
    my $date = qx/date +"%Y-%m-%d %H:%M:%S" -d\@$tsSecPart/;
    chomp $date;
    $tsMsPart = substr "000".$tsMsPart, -3;
    print "$eventTime\t$tsMs\t$date,$tsMsPart\n";
  }
}
