requires 'perl', '5.010';

requires 'Mojolicious';
requires 'IO::Socket::Timeout';
requires 'IO::Socket::UNIX';

on 'test' => sub {
    requires 'File::Spec';
    requires 'File::Temp';
    requires 'List::Util';
    requires 'Test::More', '0.96';
};
