#!/usr/bin/perl
use REST::Client;
use JSON;
use JSON::XS;
use Data::Dumper;
use MIME::Base64;
use IO::Socket::SSL qw( SSL_VERIFY_NONE );
$ENV{PERL_LWP_SSL_VERIFY_HOSTNAME}=0;

my $username = 'admin';
#my $username = 'root';
my $password = 'password';
#my $password = '12!pass345';
my $headers = {Accept => 'application/json', Authorization => 'Basic ' . encode_base64($username . ':' . $password), Content-type => 'application/json'};
my $host = REST::Client->new();
$host->getUseragent()->ssl_opts( SSL_verify_mode => 0 );
#$host->setHost('https://192.168.29.22:8080');
#$host->setHost('https://172.16.250.2:8080');
$host->setHost('https://172.24.1.210:8080');
#$host->GET('/platform/1/protocols/nfs/exports?describe',$headers);

sub getNFSExports
{
    my $host= shift;
    $host->GET('/platform/1/protocols/nfs/exports', $headers);
    my $text = $host->responseContent();

    my $json_ref = decode_json $text;
    print "text = " . $text . "\n";
    my @exports = @{$json_ref->{exports}};
    print $json_ref . "\n";
    print Dumper($json_ref);

    return \@exports;
}

sub printNFSExports
{
    my $exports_ref = shift;
    my $i = 1;
    foreach $export_ref (@{$exports_ref}) {
        print "Export " . $i . ":\n";
        my @paths = @{$export_ref->{paths}};
        foreach $path (@paths) {
            print "    path = " . $path . "       ";
        }
        my @roclients = @{$export_ref->{read_only_clients}};
        foreach $client (@roclients) {
            print $client . "(ro) ";
        }
        my @rootclients = @{$export_ref->{root_clients}};
        foreach $client (@rootclients) {
            print $client . "(root) ";
        }
        my @clients = @{$export_ref->{clients}};
        foreach $client (@clients) {
            print $client . "() ";
        }
        $i++;
        print "\n\n";
    }

    return 1;
}

sub getCIFSExports
{
    my $host= shift;
    $host->GET('/platform/1/protocols/smb/shares', $headers);
    my $text = $host->responseContent();

    my $json_ref = decode_json $text;
    print "text = " . $text . "\n";
    my @exports = @{$json_ref->{shares}};
    print $json_ref . "\n";
    print Dumper($json_ref);

    return \@exports;
}

sub printCIFSExports
{
    my $exports_ref = shift;
    my $i = 1;
    foreach $export_ref (@{$exports_ref}) {
        print "Export " . $i . ":\n";
        my $path = $export_ref->{path};
        print "    path = " . $path;
        my $name = $export_ref->{name};
        print "    name = " . $name;
        $i++;
        print "\n\n";
    }

    return 1;
}

sub createNFSExport
{
    my $host = shift;
    my $path = shift;
    my $prop_ref = shift;
    my $client_ref = shift;

    my $req;
    if ($prop_ref->{ro} && $prop_ref->{ro} ne 'false') {
        $req->{read_only} = JSON::XS::true;
    } else {
        $req->{read_only} = JSON::XS::false;
    }
    $req->{paths} = [ $path ];
    if ($client_ref) {
        if ($client_ref->{root_clients}) {
            $req->{root_clients} = $client_ref->{root_clients};
        }
        if ($client_ref->{read_only_clients}) {
            $req->{read_only_clients} = $client_ref->{read_only_clients};
        }
    }
    my $req_texts = encode_json $req;
    print "req = " . $req_texts . "\n";
    $host->POST('/platform/1/protocols/nfs/exports', encode_json $req, $headers);
    print $host->responseContent();
}

sub deleteNFSExport
{
    my $host = shift;
    my $path = shift;
    my $prop_ref = shift;
    my $client_ref = shift;

    my $req;
    $req->{paths} = [ $path ];
    if ($client_ref) {
        if ($client_ref->{root_clients}) {
            $req->{root_clients} = $client_ref->{root_clients};
        }
        if ($client_ref->{read_only_clients}) {
            $req->{read_only_clients} = $client_ref->{read_only_clients};
        }
    }
    my $req_texts = encode_json $req;
    print "req = " . $req_texts . "\n";
    $host->DELETE('/platform/1/protocols/nfs/exports', encode_json $req, $headers);
    print $host->responseContent();
}

sub deleteCIFSExport
{
    my $host = shift;
    my $share = shift;

    my $path = '/platform/1/protocols/smb/shares/' . $share;
    my $req;
    $host->DELETE($path, $req, $headers);
    print $host->responseContent();
}

sub createCIFSExport
{
    my $host = shift;
    my $path = shift;
    my $prop_ref = shift;
    my $client_ref = shift;

    my $req;
    if ($prop_ref) {
        if ($prop_ref->{browsable}) {
            $req->{browsable} = $client_ref->{browsable};
        } else {
            $req->{browsable} = JSON::XS::true;
        }
        if ($prop_ref->{hide_dot_files}) {
            $req->{hide_dot_files} = $client_ref->{hide_dot_files};
        } else {
            $req->{hide_dot_files} = JSON::XS::true;
        }
    }
    #$req->{host_acl} = [ "deny: ALL" ];
    #$req->{host_acl} = [ "deny: 192.168.29.14" ];
    #$req->{host_acl} = [ "allow:172.16.129.116", "deny:ALL" ];
    #$req->{host_acl} = [ "deny:ALL",  "allow:172.16.129.116",  "allow:192.168.29.15" ];
    $req->{host_acl} = [ "allow:172.17.138.36", "allow:172.17.129.115", "deny:ALL" ];
    $req->{name} = "test";
    $req->{path} = $path;
    my $req_texts = encode_json $req;
    print "req = " . $req_texts . "\n";
    $host->POST('/platform/1/protocols/smb/shares', encode_json $req, $headers);
    print $host->responseContent();
}

sub getSnapList
{
    my $host = shift;
    $host->GET('/platform/1/snapshot/snapshots?sort=id', $headers);
    my $text = $host->responseContent();

    my $json_ref = decode_json $text;
    my @snapshots = @{$json_ref->{snapshots}};
    #print $json_ref . "\n";
    #print Dumper($json_ref);

    return \@snapshots;
}

sub printhash
{
    my $myhash = shift;
    foreach (sort keys %myhash) {
        print "$_ : $myhash{$_}\n";
    }
}

sub printSnapshots
{
    my $snaps_ref = shift;
    printf "%4s   %-30s %-30s %s\n", "ID", "Snapshot", "Path", "Expires";
    printf "%4s   %-30s %-30s %s\n", "--", "--------", "----", "-------";
    foreach $snap_ref (@{$snaps_ref}) {
        printf "%4s   %-30s %-30s %s\n", $snap_ref->{id}, $snap_ref->{name}, $snap_ref->{path}, $snap_ref->{expires};
        #print Dumper($snap_ref);
    }

    return 1;
}

sub deleteSnapshot
{
    my $host = shift;
    my $snapName = shift;

    $host->DELETE('/platform/1/snapshot/snapshots/' . $snapName, $headers);
    print $host->responseContent();
}

sub createSnapshot 
{
    my $host = shift;
    my $snapName = shift;
    my $path = shift;

    my $req;
    $req->{name} = $snapName;
    $req->{path} = $path;
    $host->POST('/platform/1/snapshot/snapshots', encode_json $req, $headers);
    print $host->responseContent();
}

sub printSession
{
    my $host = shift;
    $host->GET('/session/1/session', $headers);
    my $text = $host->responseContent();
    my $json_ref = decode_json $text;
    print Dumper($json_ref);
}

sub setExpiry
{
    my $host = shift;
    my $snap = shift;
    my $req;
    $req->{expires} = 1404563231;
    $host->PUT("/platform/1/snapshot/snapshots/$snap", encode_json $req, $headers);
}

#my $exports_ref = getNFSExports $host;
 $exports_ref;
#$exports_ref = getCIFSExports $host;
#printCIFSExports $exports_ref;
#createNFSExport $host, '/ifs/bhargava/.snapshot/snap1',  { 'ro' => 'true' }, { 'root_clients' => [ '192.168.29.14' ], { 'force' => 'true' } };
#deleteCIFSExport $host, 'test';
createCIFSExport $host, '/ifs/.snapshot/ACTSNAP_22668608_22691742_1453433471780/cifs/sm',  { 'ro' => 'true' }, { 'root_clients' => [ '192.168.29.14' ], { 'force' => 'true' } };
#$exports_ref = getCIFSExports $host;
#printCIFSExports $exports_ref;
#deleteNFSExport $host, '/ifs/bhargava/.snapshot/snap1/a', { 'root_clients' => [ '192.168.29.14' ] };
#my $snapshots_ref = getSnapList $host;
#printSnapshots $snapshots_ref;
#setExpiry $host, "ACTSNAP_16433_0022778_1404033914691";
exit 0;
my $snapshots_ref = getSnapList $host;
printSnapshots $snapshots_ref;
deleteSnapshot $host, 'snap3';
$snapshots_ref = getSnapList $host;
printSnapshots $snapshots_ref;
createSnapshot $host, 'snap3', '/ifs/data';
$snapshots_ref = getSnapList $host;
printSnapshots $snapshots_ref;

exit;
