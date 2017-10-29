use strict;
use warnings;

use Test::More;
use Test::Mojo;

use File::Spec::Functions qw(catfile);
use File::Temp qw(tempdir);
use IO::Socket::UNIX;
use Mojo::Util qw(b64_encode);

use FindBin;
require "$FindBin::Bin/../nginx-auth-saslauthd";

my $cred_good = b64_encode( "perl:good",  q{} );
my $cred_bad  = b64_encode( "python:bad", q{} );

my $dir = tempdir( CLEANUP => 1 );
my $path = catfile( $dir, 'mux' );

my $child_is_ready = 0;
$SIG{USR1} = sub { $child_is_ready = 1 };

sub read_string {
    my $sock = shift;

    my $s = '';
    my $n;
    if ( defined $sock->recv( $n, 2 ) ) {
        my $len = unpack 'n', $n;
        if ( $len > 0 ) {
            $sock->recv( $s, $len );
        }
    }
    return $s;
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
        my $reply = (
            4 == grep { $_ eq read_string($client) }
            qw(perl good Mojolicious mojolicious.org)
        ) ? 'OK' : 'NO';
        $client->send( pack 'n/a*', $reply );
    }

    exit 0;
}

sleep 5;
plan skip_all => 'could not create socket' if !$child_is_ready;

my $t = Test::Mojo->new;

$t->get_ok( '/auth-basic' => { 'X-Realm' => 'Perl' } )->status_is(401)
    ->header_is( 'WWW-Authenticate' => qq{Basic realm="Perl"} );

$t->get_ok(
    '/auth-basic' => {
        'Authorization'       => "Basic $cred_good",
        'X-Saslauthd-Path'    => $path,
        'X-Saslauthd-Timeout' => 5,
        'X-Saslauthd-Service' => 'Mojolicious',
        'X-Saslauthd-Realm'   => 'mojolicious.org',
    }
)->status_is(200);

$t->get_ok(
    '/auth-basic' => {
        'Authorization'       => "Basic $cred_bad",
        'X-Saslauthd-Path'    => $path,
        'X-Saslauthd-Timeout' => 5,
    }
)->status_is(401);

kill 'TERM', $child_pid;
waitpid $child_pid, 0;

done_testing;
