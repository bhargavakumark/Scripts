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

my $ip = $ARGV[0];

#Add Keys to authorised keys in B
print "Adding Keys to authorised key in B with IP=$ip,[ $login $password ] \n";
$password = "master";
$timeout = 30;
my $aft = new Expect;
$aft->spawn("ssh -o \"UserKnownHostsFile=/dev/null\" -o \"StrictHostKeyChecking no\" master\@$ip") or die "Cannot ssh to the machine \n";
$aft->expect($timeout,[ qr'\? $',     sub { my $fh=shift;$fh->send("yes\n"); exp_continue; } ],
    	              [ 'Password: $',sub { my $fh=shift;$fh->send("$password\n");exp_continue;}  ],  
		       '-re','> $'	
		  ) or die "Cannot authenticate";
$aft->send("admin\n");
$aft->expect(5,'-re','> $');
$aft->send("supportuser enable\n");
$aft->expect(5,'-re','> $');
$aft->do_soft_close();


exit 0


