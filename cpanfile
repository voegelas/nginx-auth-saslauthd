requires 'perl', '5.016';

requires 'Mojolicious', '8.0';

on 'test' => sub {
    requires 'File::Spec';
    requires 'File::Temp';
    requires 'IO::Socket::UNIX';
    requires 'Test::More', '0.96';
};
