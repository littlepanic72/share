#!/usr/bin/perl -w
#===============================================================================
#
#         FILE: Insert.pl
#
#        USAGE: ./Insert.pl  
#
#  DESCRIPTION: 
#
#      OPTIONS: ---
# REQUIREMENTS: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: YOUR NAME (), 
# ORGANIZATION: 
#      VERSION: 1.0
#      CREATED: 2014/01/08 13时06分13秒
#     REVISION: ---
#===============================================================================

use strict;
use warnings;
use utf8;
use DBI;


my $dbh = DBI->connect("dbi:SQLite:dbname=./info.db",'','',{
        RaiseError => 1,
        AutoCommit => 1
        }   
    );  
$dbh->do("PRAGMA cache_size = 800000");

$dbh->do(<<EOF);
CREATE TABLE IF NOT EXISTS lp_his
(
	code	varchar(20),
    date    varchar(30) ,
	open    float,
	high	float,
	low		float,
	close	float,
	volume	float,
	adj_close	float
)
EOF

my $dirpath ='./his';
my $sql;
my $code;
opendir my $dir , $dirpath or die "can not open dir $dirpath";
while (my $file = readdir $dir)
{
	next if $file eq '.' || $file eq '..';
	next unless $file =~ /\.csv$/;
	#print $file;
	open my $in , " < $dirpath/$file" or die "can not open file $file";
	$code = $file;
	$code =~ s/\D//g;
	while(<$in>)
	{
		chomp;
		my @arr = split ",",$_;
		print "$file \n" unless @arr==7;
		$sql = "insert into lp_his values('$code','$arr[0]','$arr[1]','$arr[2]','$arr[3]','$arr[4]','$arr[5]','$arr[6]')";
		#print $sql;
		$dbh->do($sql);
		if($dbh->err())
		{
		   die "$DBI::errstr\n";
		}
		#$dbh->commit();
	}
	close $in;
}


close $dir;

$dbh->disconnect();
