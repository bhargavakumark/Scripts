#!/usr/bin/perl
# $Id: genkey.pl,v 1.1 2007/03/28 08:44:21 vgupta Exp $
# #ident "@(#)nasgw:$RCSfile: genkey.pl,v $ $Revision: 1.1 $"
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

my $private_key='/root/.ssh/id_rsa';
my $public_key='/root/.ssh/id_rsa.pub';

if(!(( -e $public_key ) &&( -e $private_key)))  {
    print "Generating the Public and Private Key:\n";
    @result=`ssh-keygen -t rsa -f /root/.ssh/id_rsa -P ""`;
    print @result;
}
