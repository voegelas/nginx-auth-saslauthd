use strict;
use warnings;

use 5.016;
use ExtUtils::MakeMaker;

die "OS unsupported\n" if $^O eq 'MSWin32';

package MY;

sub constants {
  my $self = shift;

  my $text = $self->SUPER::constants(@_);
  if (defined $text) {
    $text =~ s{/bin$}{/sbin}mg;
    $text =~ s{/man1$}{/man8}mg;
    $text =~ s{^(MAN1(?:EXT|SECTION)\h*=\h*)1([[:alpha:]]*)$}{${1}8}mg;
  }

  return $text;
}

package main;

my %WriteMakefileArgs = (
  NAME => 'App::nginx_auth_saslauthd',
  DISTNAME => 'nginx-auth-saslauthd',
  ABSTRACT => 'Verify web users with Basic authentication and saslauthd',
  AUTHOR => 'Andreas V\x{f6}gele <andreas@andreasvoegele.com>',
  VERSION_FROM => 'bin/nginx-auth-saslauthd',
  LICENSE => 'open_source',
  EXE_FILES => [
    'bin/nginx-auth-saslauthd'
  ],
  PM => {},
  NO_PACKLIST => 1,
  NO_PERLLOCAL => 1,
  MIN_PERL_VERSION => '5.016',
  CONFIGURE_REQUIRES => {
    'ExtUtils::MakeMaker' => 0
  },
  PREREQ_PM => {
    'English' => 0,
    'Mojo::IOLoop' => 0,
    'Mojo::Util' => 0,
    'Mojolicious' => '7.27',
    'Mojolicious::Lite' => 0,
    'strict' => 0,
    'warnings' => 0
  },
  TEST_REQUIRES => {
    'Mojo::File' => 0,
    'IO::Socket::UNIX' => 0,
    'Test::Mojo' => 0,
    'Test::More' => '0.96',
    'version' => '0.77'
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
