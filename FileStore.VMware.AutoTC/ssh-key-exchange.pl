#!/usr/bin/perl
# $Id: ssh-key-exchange.pl,v 1.8.10.3 2009/09/04 12:13:20 ssarabu Exp $
# #ident "@(#)nasgw:$RCSfile: ssh-key-exchange.pl,v $ $Revision: 1.8.10.3 $"
# # $Copyrights: Copyright (c) 2009 Symantec Corporation.
# # All rights reserved.
# #
# # THIS SOFTWARE CONTAINS CONFIDENTIAL INFORMATION AND TRADE SECRETS OF
# # SYMANTEC CORPORATION.  USE, DISCLOSURE OR REPRODUCTION IS PROHIBITED
# # WITHOUT THE PRIOR EXPRESS WRITTEN PERMISSION OF SYMANTEC CORPORATION.
# #
# # The Licensed Software and Documentation are deemed to be commercial
# # computer software as defined in FAR 12.212 and subject to restricted
# # rights as defined in FAR Section 52.227-19 "Commercial Computer
# # Software - Restricted Rights" and DFARS 227.7202, "Rights in
# # Commercial Computer Software or Commercial Computer Software
# # Documentation", as applicable, and any successor regulations. Any use,
# # modification, reproduction release, performance, display or disclosure
# # of the Licensed Software and Documentation by the U.S. Government
# # shall be solely in accordance with the terms of this Agreement.  $ 

use Expect;

my $home = "$ENV{HOME}";

my $ip = $ARGV[0];
my $login = "root";
my $password = "$ARGV[1]";
my $private_key="$home/.ssh/id_rsa";
my $public_key="$home/.ssh/id_rsa.pub";
my $authorisedkeyfile="$home/.ssh/authorized_keys";
my $genkey="/mnt/sdd1/tc/genkey.pl";
my $timeout = 30;
my $aft = new Expect;

#Generate the public and private key on the local m/c A
if(!(( -e $public_key ) &&( -e $private_key)))  {
    print "Generating the Public and Private Key:\n";
    @result=`ssh-keygen -t rsa -f $private_key -P ""`;
    #print @result;
}
#Copy the file to m/c B
print "Copying Public Key from A to B.\n";
$aft->spawn("scp $public_key $genkey $login\@$ip:/tmp/");
$aft->expect($timeout,[ qr'\? $',     sub { my $fh=shift;$fh->send("yes\n"); exp_continue; } ],
    	              [ 'assword: $',sub { my $fh=shift;$fh->send("$password\n");exp_continue;}  ],  
#		       '-re','\# $'	
		  );
$aft->do_soft_close();		  


#Add Keys to authorised keys in B
print "Adding Keys to authorised key in B with IP=$ip,[ $login $password ] \n";
my $aft = new Expect;
$aft->spawn("ssh $login\@$ip") or die "Cannot ssh to the machine \n";
#$aft->raw_pty(0);
##$aft->log_stdout(0);
$aft->expect($timeout,[ qr'\? $',     sub { my $fh=shift;$fh->send("yes\n"); exp_continue; } ],
    	              [ 'assword: $',sub { my $fh=shift;$fh->send("$password\n");exp_continue;}  ],  
		       '-re','\# $'	
		  ) or die "cannot ssh";
$aft->send("mkdir -p /root/.ssh\n");
$aft->expect($timeout,'-re','\# $');
$aft->send("touch /root/.ssh/authorized_keys\n");
$aft->expect($timeout,'-re','\# $');
$aft->send("cat /tmp/id_rsa.pub >> /root/.ssh/authorized_keys;rm /tmp/id_rsa.pub\n");
$aft->expect($timeout,'-re','\# $');
$aft->send("/usr/bin/perl /tmp/genkey.pl\n");
$aft->expect($timeout,'-re','\# $');
$aft->send("sync;sync;\n");
$aft->expect($timeout,'-re','\# $');
$aft->send("exit\n");
$aft->do_soft_close();		  


print "Copying the public key from B to A";
my $aft = new Expect;
$aft->spawn("scp $login\@$ip:$public_key /tmp/id_rsa.pub");
$aft->expect($timeout,[ qr'\? $',     sub { my $fh=shift;$fh->send("yes\n"); exp_continue; } ],
    	              [ 'assword: $',sub { my $fh=shift;$fh->send("$password\n");exp_continue;}  ],  
#		       '-re','\# $'	
		  );
$aft->do_soft_close();		  

print "Adding Keys to authorised key in A\n" ;
print `cat /tmp/id_rsa.pub >> $authorisedkeyfile`;
print `rm /tmp/id_rsa.pub`;
print `sync;sync;`;
print `sleep 1`;

# Verify if the key has been exchanged or not
my $aft = new Expect;
$aft->spawn("ssh $login\@$ip") or die "Cannot ssh to the machine $ip\n";
$aft->expect($timeout,[ qr'\? $',     sub { my $fh=shift;$fh->send("yes\n"); exp_continue; } ],
    	              [ qr/ssword: $/i,sub { exit -1;}  ],  
		       '-re','\# $'	
		  ) or die "cannot ssh to machine $ip\n";
#$aft->send("exit\n");
$aft->do_soft_close();		  

exit 0


