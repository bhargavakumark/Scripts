#!/usr/bin/perl

use Expect;

my $ip = $ARGV[0];
my $login = "root";
my $password = "$ARGV[1]";
my $private_key='/root/.ssh/id_rsa';
my $public_key='/root/.ssh/id_rsa.pub';
my $authorisedkeyfile='/root/.ssh/authorized_keys';
my $genkey='/opt/VRTSnasgw/install/genkey.pl';
my $timeout = 30;
my $aft = new Expect;

#Start ssh if not running on local m/c
print `/etc/init.d/sshd start`;

#Generate the public and private key on the local m/c A
if(!(( -e $public_key ) &&( -e $private_key)))  {
    print "Generating the Public and Private Key:\n";
    @result=`ssh-keygen -t rsa -f /root/.ssh/id_rsa -P ""`;
    #print @result;
}
#Copy the file to m/c B
print "Copying Public Key from A to B.\n";
$aft->spawn("scp $public_key $genkey $login\@$ip:/tmp/");
$aft->expect($timeout,[ qr'\? $',     sub { my $fh=shift;$fh->send("yes\n"); exp_continue; } ],
    	              [ 'Password: $',sub { my $fh=shift;$fh->send("$password\n");exp_continue;}  ],  
#		       '-re','\# $'	
		  );
$aft->do_soft_close();		  


#Add Keys to authorised keys in B
print "Adding Keys to authorised key in B with IP=$ip,[ $login $password ] \n";
my $aft = new Expect;
$aft->log_file("/tmp/expect_log","w");
$aft->spawn("ssh $login\@$ip") or die "Cannot ssh to the machine \n";
#$aft->raw_pty(0);
##$aft->log_stdout(0);
$aft->expect($timeout,[ qr'\? $',     sub { my $fh=shift;$fh->send("yes\n"); exp_continue; } ],
    	              [ 'Password: $',sub { my $fh=shift;$fh->send("$password\n");exp_continue;}  ],  
		       '-re','\# $'	
		  ) or die "cannot ssh";
$aft->send("mkdir -p /root/.ssh\n");
$aft->expect($timeout,'-re','\# $');
$aft->send("touch $authorisedkeyfile\n");
$aft->expect($timeout,'-re','\# $');
$aft->send("cat /tmp/id_rsa.pub >> $authorisedkeyfile;rm /tmp/id_rsa.pub\n");
$aft->expect($timeout,'-re','\# $');
$aft->send("exit\n");
$aft->do_soft_close();		  

exit 0

