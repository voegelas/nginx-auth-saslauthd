use strict;
use warnings;

use 5.016;

use ExtUtils::MakeMaker;

my %WriteMakefileArgs = (
  NAME => 'App::nginx_auth_saslauthd',
  DISTNAME => 'nginx-auth-saslauthd',
  ABSTRACT => 'Verify web users with Basic authentication and saslauthd',
  AUTHOR => 'Andreas V\x{f6}gele <voegelas@cpan.org>',
  VERSION_FROM => 'bin/nginx-auth-saslauthd',
  LICENSE => 'open_source',
  EXE_FILES => [
    'bin/nginx-auth-saslauthd'
  ],
  NO_PACKLIST => 1,
  NO_PERLLOCAL => 1,
  MIN_PERL_VERSION => '5.016',
  CONFIGURE_REQUIRES => {
    'ExtUtils::MakeMaker' => 0
  },
  PREREQ_PM => {
    'Mojolicious' => '7.27'
  },
  TEST_REQUIRES => {
    'File::Spec' => 0,
    'File::Temp' => 0,
    'IO::Socket::UNIX' => 0,
    'Test::More' => '0.96'
  },
  test => {
    TESTS => 't/*.t'
  }
);

unless ( eval { ExtUtils::MakeMaker->VERSION(6.75_01) } ) {
  delete $WriteMakefileArgs{NO_PACKLIST};
  delete $WriteMakefileArgs{NO_PERLLOCAL};
}

WriteMakefile(%WriteMakefileArgs);
