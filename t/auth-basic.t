use strict;
use warnings;

use Test::More;
use Test::Mojo;

use File::Spec::Functions qw(catfile);
use File::Temp qw(tempdir);
use IO::Socket::UNIX;
use Mojo::Util qw(b64_encode decode);

my @good_values = map { decode( 'ISO-8859-1', $_ ) }
    ( "Lemmy", "Mot\366rhead", "Moj\366licious", "moj\366licious.org" );
my $cred_good = b64_encode( "Lemmy:Mot\303\266rhead", q{} );
my $cred_bad  = b64_encode( "Lemmy:Motorhead",        q{} );

my $dir = tempdir( CLEANUP => 1 );
my $path = catfile( $dir, 'mux' );
$ENV{MOJO_CONFIG} = catfile( $dir, 'nonexistent.conf' );

my $child_is_ready = 0;
$SIG{USR1} = sub { $child_is_ready = 1 };

sub read_bytes {
    my $sock = shift;

    my $s = q{};
    my $n;
    if ( defined $sock->recv( $n, 2 ) ) {
        my $len = unpack 'n', $n;
        if ( $len > 0 ) {
            $sock->recv( $s, $len );
        }
    }
    return $s;
}

sub read_string {
    my $sock = shift;

    return decode( 'UTF-8', read_bytes($sock) );
}

# Mock saslauthd.
my $parent_pid = $$;
my $child_pid  = fork;
plan skip_all => 'could not create child process' if !defined $child_pid;
if ( $child_pid == 0 ) {
    my $server = IO::Socket::UNIX->new(
        Type   => SOCK_STREAM,
        Local  => $path,
        Listen => 1,
    ) or die qq{$path: $!};

    # Tell the parent that we are ready.
    kill 'USR1', $parent_pid;

    my $client;
    while ( $client = $server->accept ) {
        my $ok = ( 4 == grep { read_string($client) eq $_ } @good_values );
        $client->send( pack 'n/a*', $ok ? 'OK' : 'NO' );
        close $client;
    }

    exit 0;
}

sleep 5;
plan skip_all => 'could not create socket' if !$child_is_ready;

my $t = Test::Mojo->new(
    Mojo::File->new('bin/nginx-auth-saslauthd'),
    {   path    => $path,
        timeout => 5,
        service => $good_values[2],
        realm   => $good_values[3],
    }
);

$t->get_ok( '/auth-basic' => { 'X-Realm' => q{"ASCII"} } )->status_is(401)
    ->header_is(
    'WWW-Authenticate' => q{Basic realm="\"ASCII\"", charset="UTF-8"} );

$t->get_ok( '/auth-basic' => { 'Authorization' => "Basic $cred_good" } )
    ->status_is(200);

$t->get_ok( '/auth-basic' => { 'Authorization' => "Basic $cred_bad" } )
    ->status_is(401);

kill 'TERM', $child_pid;
waitpid $child_pid, 0;

done_testing;
