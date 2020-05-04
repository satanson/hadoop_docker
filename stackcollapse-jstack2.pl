#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;
use Getopt::Long;

our ($OPT_includeThreadInfo)=(0, undef); 
sub options() { map {/^OPT_(\w+)\b$/; ("$1=s" => eval "*${_}{SCALAR}")} grep {/^OPT_\w+\b$/} keys %:: }
sub usage(){
  my $name = qx(basename $0); chomp $name;
  "USAGE:\n\t" . "$name " . join " ", map{/^OPT_(\w+)$/; "--$1"} grep {/^OPT_\w+\b$/} keys %::;
}

sub show(){
  print STDERR join " ", map {/^OPT_(\w+)\b$/; ("--$1=" . eval "\$$_" ) } grep {/^OPT_\w+\b$/} keys %::;
  print STDERR "\n";
}

GetOptions(options()) or die usage();

use constant {
  SECT_THREAD=>1,
  SECT_THREAD_STATE=>2,
  SECT_AT=>3,
  SECT_DASH=>4,
  SECT_BL=>5,
  SECT_UNKNOWN=>6,
};

sub recognize($){
  local $_ = shift;
  if (/^"(.*?)"\s+#\d+\s*(daemon?)\s*prio=\d+\s*os_prio=\d+\s*tid=(0x[\d+a-f]+)/){
    return (SECT_THREAD, $1, $2?1:0, $3);
  } elsif (/^\s+java.lang.Thread.State: (\w+)/) {
    return (SECT_THREAD_STATE, $1);
  } elsif (/^\s+at\s+[\w.\$]+\.([\w+\$]+\.\w+)/) {
    return (SECT_AT, $1);
  } elsif (/^\s+-\s+/) {
    return (SECT_DASH);
  } elsif (/^\s+$/) {
    return (SECT_BL);
  } else {
    return (SECT_UNKNOWN);
  }
}

sub sect_thread(\%@){
  my ($ctx,$threadName, $isDaemon, $threadId)=@_;
  $ctx->{partial}=[];
  $ctx->{thread}{name}=$threadName;
  $ctx->{thread}{daemon}=$isDaemon;
  $ctx->{thread}{id}=$threadId;
}

sub sect_thread_state(\%@){
  my ($ctx,$threadState) = @_;
  $ctx->{thread}{state}=$threadState;
}

sub sect_at(\%@){
  my ($ctx,$func)=@_;
  unshift @{$ctx->{partial}}, $func;
}

sub sect_bl(\%@){
  my ($ctx,@args)=@_;
  my $partial=$ctx->{partial};
  if (!defined($partial) || scalar(@$partial)==0){
    $ctx->{partial}=undef;
    return;
  }
  #print Dumper($ctx);
  #print Dumper($partial);
  my %thread=%{$ctx->{thread}};
  my $threadInfo = sprintf "%s(daemon:%s,id:%s)", @thread{qw/name daemon id/};
  unshift @$partial, $threadInfo;
  my $result=join ";", @$partial;
  push @{$ctx->{stacks}}, [@$partial];
  $ctx->{partial}=undef;
  $ctx->{thread}=undef;
}

sub sect_init() {
  {
    state=>SECT_BL,
    thread=>{},
    partial=>undef,
    stacks=>[],
  };
}

sub sect_nop(\%@){
}

sub sect_err($@){
  my $ctx = shift;
  $ctx->{thread}={};
  $ctx->{state}=SECT_UNKNOWN;
  $ctx->{partial}=undef;
}

my $stateTrans={
  "".SECT_UNKNOWN.":".SECT_THREAD, \&sect_thread,
  "".SECT_BL.":".SECT_THREAD, \&sect_thread,

  "".SECT_THREAD.":".SECT_THREAD_STATE, \&sect_thread_state,

  "".SECT_THREAD_STATE.":".SECT_AT, \&sect_at,
  "".SECT_DASH.":".SECT_AT, \&sect_at,
  "".SECT_AT.":".SECT_AT, \&sect_at,

  "".SECT_THREAD_STATE.":".SECT_DASH, \&sect_nop,
  "".SECT_AT.":".SECT_DASH, \&sect_nop,
  "".SECT_DASH.":".SECT_DASH, \&sect_nop,

  "".SECT_AT.":".SECT_BL, \&sect_bl,
  "".SECT_DASH.":".SECT_BL, \&sect_bl,

  "".SECT_BL  .":".SECT_BL, \&sect_nop,
  "".SECT_UNKNOWN.":".SECT_BL, \&sect_nop,
  "".SECT_BL.":".SECT_UNKNOWN, \&sect_nop,
  "".SECT_UNKNOWN.":".SECT_UNKNOWN, \&sect_nop,
};

#print Dumper($stateTrans);

sub transfer($@){
  my ($ctx, $state, @args)=@_;
  #print Dumper($ctx);
  my $prevState=$ctx->{"state"};
  my $key="".$prevState.":".$state;
  if (!exists $stateTrans->{$key}){
    sect_err($ctx);
  } else {
    $stateTrans->{$key}($ctx, @args);
    $ctx->{state}=$state;
  }
}

my $ctx = sect_init();

while(<>){
  #print "$.:$_\n";
  my @a=recognize($_);
  transfer($ctx, @a);
}
transfer($ctx, SECT_BL);

my $stacks=$ctx->{stacks};
if (!$OPT_includeThreadInfo) {
  $stacks = [map {shift @$_;$_} @$stacks];
}

my %stacks=();
foreach (@$stacks){
  my $stk=join ";", @$_;
  $stacks{$stk}+=1;
}

print join "\n",map {$_." ".$stacks{$_}} keys %stacks;
