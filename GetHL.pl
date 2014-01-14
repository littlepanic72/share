#!/usr/bin/env perl 
#===============================================================================
#
#         FILE: GetHL.pl
#
#        USAGE: ./GetHL.pl  
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
#      CREATED: 2014/01/13 18时42分21秒
#     REVISION: ---
#===============================================================================

use strict;
use warnings;
use utf8;
use DBI;


my $dbh = DBI->connect("dbi:SQLite:dbname=./info.db",'','',{
        RaiseError => 1,
        AutoCommit => 0
        }   
    );  
my @arrDays = (1,5,10,20,60,120,240,365);

foreach my $days(@arrDays)
{
	GetHL('2014-01-10',$days);
}

$dbh->disconnect();

sub GetHL
{
	my $date = shift;
	my $days	= shift;
	my $sql ="select date from lp_his where date='$date'";
    my $dbc = $dbh->prepare($sql);
	$dbc->execute();
	unless( $dbc->fetchrow_array)
	{
		print "can not find date $date\n";
		return;	
	}
    
	
	$dbh->do(<<EOF);
	CREATE TABLE IF NOT EXISTS p_date
	(
		date	varchar(20)
	)
EOF
   
    $sql = "delete from p_date";
	$dbh->do($sql);
    
	$sql = "insert into p_date select distinct date from lp_his where date<='$date' order by date desc limit $days";
   print $sql;
	$dbh->do($sql);
	$sql="insert into lp_hl select '$date',code,'$days',max(high),min(low) from lp_his a join p_date b on a.date=b.date group by '$date',code,'$days'";
	$dbh->do($sql);

	$dbh->commit();
}
