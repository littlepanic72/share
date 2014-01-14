#!/usr/bin/perl
use strict;

use LWP::UserAgent;
use HTTP::Cookies;
use HTTP::Headers;
use JSON;
use Data::Dumper;
use Encode;
use DBI;

use utf8;

#our $file = "c: \\ookie.txt";
#our $cookie =  HTTP::Cookies->new(file=>$file,autosave=>1);
our $browser = LWP::UserAgent->new(keep_alive => 1);
#$browser->cookie_jar($cookie);
#our $proxy = $browser->proxy(http=>'http://cmproxy.XXXX.net:8081');
my $count=3000;
my  $url ="http://quotes.money.163.com/hs/service/diyrank.php?host=http%3A%2F%2Fquotes.money.163.com%2Fhs%2Fservice%2Fdiyrank.php&page=0&query=STYPE%3AEQA&fields=SYMBOL%2CNAME%2CPRICE%2CPERCENT%2CUPDOWN%2CFIVE_MINUTE%2COPEN%2CYESTCLOSE%2CHIGH%2CLOW%2CVOLUME%2CTURNOVER%2CHS%2CLB%2CPE%2CMCAP%2CTCAP%2CMFSUM%2CMFRATIO.MFRATIO2%2CMFRATIO.MFRATIO10%2CSNAME%2CCODE%2CANNOUNMT%2CUVSNEWS&sort=SYMBOL&order=asc&count=$count&type=query";

my $response = $browser->get($url);
#print $response->is_success;
my $json = new JSON;
my $obj = $json->decode($response->content);
#print "The structure of obj: ".Dumper($obj);


print encode("utf8","每股收益｜主营收｜净利润｜代码｜五分钟涨跌｜成交额｜总市值｜价格｜量比｜涨跌幅｜今开｜名称｜换手率｜名称2｜代码2｜昨收｜最低｜成交量｜市盈率｜流通市值｜最高｜涨跌额｜\n");

my $dbh = DBI->connect("dbi:SQLite:dbname=./info.db",'','',{
        RaiseError => 1,
        AutoCommit => 0
        }   
    );  
$dbh->do(<<EOF);
CREATE TABLE IF NOT EXISTS lp_share
(
	时间    varchar(30) ,
	代码    varchar(20) ,
	名称	varchar(20),
	价格	float,
	涨跌幅  flaot,
	市盈率	float,
	每股收益	float,
	净利润	float,
	主营收	float,
	总市值	float,
	流通市值	float,
	成交额 flaot,
	成交量 float,
	量比 flat,
	换手率 float,
	五分钟涨跌幅 float,
	最高 float,
	最低 float,
	今开 float,
	昨收 float
)
EOF
 
foreach my $i (0.. scalar(@{$obj->{list}})-1) #
{
    my $sql = "insert into lp_share values('";
    
    $sql .= $obj->{'time'} ."','"; #

    $sql .= $obj->{list}[$i]->{'SYMBOL'} ."','"; #代码
    $sql .= encode("utf8",$obj->{list}[$i]->{'NAME'}) ."','";
    $sql .= $obj->{list}[$i]->{'PRICE'} ."','";
    $sql .= $obj->{list}[$i]->{'UPDOWN'} ."','";
    $sql .= $obj->{list}[$i]->{'PE'} ."','";
    $sql .= $obj->{list}[$i]->{'MFSUM'} ."','";
    $sql .= $obj->{list}[$i]->{'MFRATIO'}->{'MFRATIO2'} ."','";
    $sql .= $obj->{list}[$i]->{'MFRATIO'}->{'MFRATIO10'} ."','";
    $sql .= $obj->{list}[$i]->{'TCAP'} ."','";
    $sql .= $obj->{list}[$i]->{'MCAP'} ."','";
    $sql .= $obj->{list}[$i]->{'TURNOVER'} ."','";
    $sql .= $obj->{list}[$i]->{'VOLUME'} ."','";
    $sql .= $obj->{list}[$i]->{'LB'} ."','";
    $sql .= $obj->{list}[$i]->{'HS'} ."','";
    $sql .= $obj->{list}[$i]->{'FIVE_MINUTE'} ."','";
    $sql .= $obj->{list}[$i]->{'HIGH'} ."','";
    $sql .= $obj->{list}[$i]->{'LOW'} ."','";
    $sql .= $obj->{list}[$i]->{'OPEN'} ."','";
    $sql .= $obj->{list}[$i]->{'YESTCLOSE'} ."')";
    
    print "$i\n"; 
    #print $sql;
    #exit(0);
    $dbh->do( $sql);
    
    if ($dbh->err()) {
        die "$DBI::errstr\n";
    }
    $dbh->commit();


    
=pod
    print $obj->{list}[$i]->{'MFSUM'};
    print "|";
    print $obj->{list}[$i]->{'MFRATIO'}->{'MFRATIO10'};
    print "|";
    print $obj->{list}[$i]->{'MFRATIO'}->{'MFRATIO2'};
    print "|";
    print $obj->{list}[$i]->{'SYMBOL'};
    print "|";
    print $obj->{list}[$i]->{'FIVE_MINUTE'};
    print "|";
    print $obj->{list}[$i]->{'TURNOVER'};
    print "|";
    print $obj->{list}[$i]->{'TCAP'};
    print "|";
    print $obj->{list}[$i]->{'PRICE'};
    print "|";
    print $obj->{list}[$i]->{'LB'};
    print "|";
    print $obj->{list}[$i]->{'PERCENT'};
    print "|";
    print $obj->{list}[$i]->{'OPEN'};
    print "|";
    #print encode("gb2312",$obj->{list}[$i]->{'NAME'});
    #print $obj->{list}[$i]->{'NAME'};
    print encode("utf8",$obj->{list}[$i]->{'NAME'});

    print "|";
    print $obj->{list}[$i]->{'HS'};
    print "|";
    #print $obj->{list}[$i]->{'SNAME'};
    #print encode("gb2312",$obj->{list}[$i]->{'SNAME'});
    print encode("utf8",$obj->{list}[$i]->{'SNAME'});

    print "|";
    print $obj->{list}[$i]->{'CODE'};
    print "|";
    print $obj->{list}[$i]->{'YESTCLOSE'};
    print "|";
    print $obj->{list}[$i]->{'LOW'};
    print "|";
    print $obj->{list}[$i]->{'VOLUME'};
    print "|";
    print $obj->{list}[$i]->{'PE'};
    print "|";
    print $obj->{list}[$i]->{'MCAP'};
    print "|";
    print $obj->{list}[$i]->{'HIGH'};
    print "|";
    print $obj->{list}[$i]->{'UPDOWN'};
    print "|";
    print "\n";
=cut

}
 
 $dbh->disconnect();

