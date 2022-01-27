requires 'perl', '5.016';

requires 'English';
requires 'Mojo::IOLoop';
requires 'Mojo::Util';
requires 'Mojolicious', '7.27';
requires 'Mojolicious::Lite';
requires 'strict';
requires 'warnings';

on 'test' => sub {
    requires 'Mojo::File';
    requires 'IO::Socket::UNIX';
    requires 'Test::Mojo';
    requires 'Test::More', '0.96';
    requires 'version', '0.77';
};
