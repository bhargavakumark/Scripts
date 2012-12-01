#!/usr/bin/perl

use WWW::Mechanize;
use HTTP::Cookies;
use Getopt::Std;

sub usage() 
{
	printf "$0 -f <downlaod_url_list_file>\n";
}

my $cookie_file = "/tmp/$$.cookies.txt";
my $cookie_jar =  HTTP::Cookies->new(File => $cookie_file, autosave => 1, autocheck => 1);

my $mech = WWW::Mechanize->new();
$mech->cookie_jar($cookie_jar);
$mech->agent_alias('Windows Mozilla');

my @playlist;
%options=();
getopts("f:",\%options);
if (defined $options{f}) {
	if (! -e $options{f}) {
		printf "does not exist\n";
	}
}

sub rename_file
{
	my $filename = shift or die "filename not passed";

	if ( -e $filename) {
		my $new_filename = "$filename.old";
		rename_file($new_filename);
		`mv $filename $new_filename`;
	}	
}

sub get_download_url 
{
	my $url = shift or die "url not passed";
	$mech->get($url);
	#print $mech->content();

	$content = $mech->content();
	#$content = `cat watch2.html`;
	my @data = split(/\n/,$content);

	foreach $line(@data) {
		if ($line =~ m/fullscreenUrl/) {
			@temp = split(/video_id=/, $line);
			@temp2 = split(/&/, $temp[1]);
			$video_id = $temp2[0];

			@temp = split(/t=/, $line);
			@temp2 = split(/&/, $temp[1]);
			$t = $temp2[0];
		}

		if ($line =~ m/meta name="title"/) {
			@temp = split(/content="/, $line);
			@temp2 = split(/"/, $temp[1]);
			@temp3 = split(/ +/, $temp2[0]);
			$title = "$temp3[0].$temp3[1].$temp3[2].flv";
			$title =~ s/;/./g;
			$title =~ s/-/./g;
		}
	}
}

$file_content = `cat $options{f}`;
@url_list = split(/\n/, $file_content);
foreach $url(@url_list) {
	printf "url $url\n";
	get_download_url("$url");
	print "title $title\n";
	rename_file($title);
	print "http://youtube.com/get_video?video_id=$video_id&t=$t\n";
	`wget -O $title "http://youtube.com/get_video?video_id=$video_id&t=$t"`;
}
exit(0);

