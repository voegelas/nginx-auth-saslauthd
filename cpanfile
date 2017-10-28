requires 'perl', '5.010';

requires 'Mojolicious', '7.27';

on 'test' => sub {
    requires 'File::Spec';
    requires 'File::Temp';
    requires 'IO::Socket::UNIX';
    requires 'Test::More', '0.96';
};
