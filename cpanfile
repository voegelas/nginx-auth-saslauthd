requires 'perl', '5.010';

requires 'Mojolicious';
requires 'IO::Socket::Timeout';
requires 'IO::Socket::UNIX';

on 'test' => sub {
    requires 'Test::More', '0.96';
};

on 'develop' => sub {
    requires 'Dist::Zilla';
    requires 'Dist::Zilla::Plugin::CopyFilesFromBuild';
    requires 'Dist::Zilla::Plugin::Prereqs::FromCPANfile';
    requires 'Software::License::ISC';
};
