#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;

my $usage="$0 <dataN> <nameN> <user> <subnet>\ni.e.:\t $0 20 4 root 192.169.10";
my $dataN=shift if @ARGV or die "$usage: missing <dataN>";
my $nameN=shift if @ARGV or die "$usage: missing <nameN>";
my $user =shift if @ARGV or die "$usage: missing <user>";
my $subnet=shift if @ARGV or die "$usage: missing <subnet>";

my @nodes=((map{"datanode$_"} 0..$dataN-1), (map{"namenode$_"} 0..$nameN-1));
#print Dumper(\@nodes);

for my $n (@nodes) {
	my @dirs=map{$n."_$_"} qw/ssh log dat/;
	my ($ssh, $log, $dat)=@dirs;

	print qq(mkdir -p @dirs);
	print "\n";
	qx(mkdir -p @dirs);
	qx(chmod 755 $ssh);
	qx(yes |ssh-keygen -C ${user}\@$n -t rsa -f $ssh/id_rsa -P "");
	qx(chmod 600 $ssh/id_rsa);

	qx(cat <<-'DONE' > $ssh/config && chmod 644 $ssh/config
	Host *
    StrictHostKeyChecking no
	DONE);
}

qx(cat *_ssh/id_rsa.pub > authorized_keys);
for my $n (@nodes) {
	my $ssh=$n."_ssh";
	qx(cp authorized_keys $ssh/ && chmod 644 $ssh/authorized_keys);
	qx(rm $ssh/id_rsa.pub);
}

my $inc=sub{my $n=shift; sub{return \do{$n++}}}->(2);
qx(echo -e "${\do{join qq[\n], map{qq/$subnet.${$inc->()}/."\t$_"} @nodes}}" > hosts);
qx(echo 127.0.0.1\tlocalhost >> hosts);
