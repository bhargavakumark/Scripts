#!/usr/bin/perl
use Expect;

my $ip = $ARGV[0];
my $login = $ARGV[1];
my $password = $ARGV[2];
my $command = $ARGV[3];
my $prompt = $ARGV[4];
my $timeout = 10;
my $aft = new Expect;

$aft->log_file("/tmp/expect_log","w");
$aft->spawn("ssh $login\@$ip") or die "Cannot ssh to the machine \n";
#$aft->raw_pty(0);
##$aft->log_stdout(0);
$aft->expect($timeout,[ qr'\? $',     sub { my $fh=shift;$fh->send("yes\n"); exp_continue; } ],
    	              [ 'password: $',sub { my $fh=shift;$fh->send("$password\n");exp_continue;}  ],  
		      ['-re','\$ $'],	
		       '-re','\> $'
		  ) or die "cannot ssh";
$aft->send("$ARGV[3]\n");
$aft->expect($timeout,[qr'\)$', sub { my $fh=shift;$fh->send("y\n");exp_continue;} ],			
		      ['-re','\$ $'],
		       '-re','\> $');
$aft->send("exit\n");
$aft->do_soft_close();		  

exit 0
