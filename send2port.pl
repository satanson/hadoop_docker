#!/usr/bin/perl 
use strict;
use warnings;
use Getopt::Long;
use IPC::Open2;
use Time::Piece;

our ($OPT_port, $OPT_ratio, $OPT_delay, $OPT_useTime)=(9999, 1, 10, 0);
sub options() { map {/^OPT_(\w+)\b$/; ("$1=s" => eval "*${_}{SCALAR}")} grep {/^OPT_\w+\b$/} keys %:: }
sub usage(){
  my $name = qx(basename $0); chomp $name;
  "USAGE:\n\t" . "$name " . join " ", map{/^OPT_(\w+)$/; "--$1"} grep {/^OPT_\w+\b$/} keys %::;
}

sub show(){
  print STDERR join " ", map {/^OPT_(\w+)\b$/; ("--$1=" . eval "\$$_" ) } grep {/^OPT_\w+\b$/} keys %::;
  print STDERR "\n";
}

sub parseTime($){
  my $e = shift;
  if ($e = ~/^(\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}),(\d{3})/) {
    my ($ts, $ms) = ($1, $2);
    $ms=$ms=~s/^0*(?=\d+)//gr;
    return Time::Piece->strptime($ts, "%Y-%m-%d %H:%M:%S")->strftime("%s")*1000+$ms;
  } else {
    return 0;
  }
}

GetOptions(options()) or die usage();
show();

my @nc=qq/nc -l -s 0.0.0.0 -p $OPT_port/;

pipe my $pipein, my $pipeout or die "pipe: $!";
my $pid=fork();
defined($pid) or die "fork: $!";

if ($pid == 0) {
  close $pipeout;
  close STDIN;
  open STDIN, "<&", $pipein or die "redirect pipein to stdin: $!";
  close $pipein;
  exec @nc or die "exec: $!";
}

close $pipein;
sleep $OPT_delay;

my $cleaner=sub{
  kill 'KILL', $pid;
  waitpid $pid, 0;
};

$SIG{__DIE__}=$cleaner;
$SIG{'INT'}=$cleaner;

select $pipeout;
local $|=1;
my $interval=1.0/$OPT_ratio;
my $prevTime=undef;
while (<>) {
  if ($OPT_useTime){
    if (/^(\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2},\d{3})\s+(.*)$/) {
      my ($ts, $event)=($1, $2);
      my $currTime = parseTime $ts;
      if (!defined($prevTime)) {
      } elsif ($currTime >= $prevTime) {
        select(undef, undef, undef, ($currTime-$prevTime)/1000);
      } else {
        die "Inconsistent emitting time: prevTime=$prevTime, currTime=$currTime";
      }
      $prevTime = $currTime;
      print "$2\n";
    } else {
      select(undef, undef, undef, $interval);
      print $_;
    }
  } else {
    select(undef, undef, undef, $interval);
    print $_;
  }
}

close $pipeout;
kill 'KILL', $pid;
waitpid $pid, 0;
