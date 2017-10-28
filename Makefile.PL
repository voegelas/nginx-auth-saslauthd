use strict;
use warnings;

use 5.010;

use ExtUtils::MakeMaker;

my %WriteMakefileArgs = (
  "NAME" => "App::Nginx::Auth::Saslauthd",
  "DISTNAME" => "nginx-auth-saslauthd",
  "ABSTRACT" => "Verify web users with Basic authentication and saslauthd",
  "AUTHOR" => "Andreas Voegele <voegelas\@cpan.org>",
  "VERSION_FROM" => "nginx-auth-saslauthd",
  "CONFIGURE_REQUIRES" => {
    "ExtUtils::MakeMaker" => 0
  },
  "EXE_FILES" => [
    "nginx-auth-saslauthd"
  ],
  "LICENSE" => "open_source",
  "MIN_PERL_VERSION" => "5.010",
  "NO_PACKLIST" => 1,
  "NO_PERLLOCAL" => 1,
  "PREREQ_PM" => {
    "IO::Socket::Timeout" => 0,
    "IO::Socket::UNIX" => 0,
    "Mojolicious" => 0
  },
  "TEST_REQUIRES" => {
    "File::Spec" => 0,
    "File::Temp" => 0,
    "List::Util" => 0,
    "Test::More" => "0.96"
  },
  "test" => {
    "TESTS" => "t/*.t"
  }
);

if (eval { ExtUtils::MakeMaker->VERSION(6.46) }) {
  $WriteMakefileArgs{META_MERGE} = {
    'meta-spec' => { version => 2 },
     resources => {
       bugtracker  => {
         web => 'https://github.com/voegelas/nginx-auth-saslauthd/issues',
       },
       repository => {
         type => 'git',
         url => 'https://github.com/voegelas/nginx-auth-saslauthd.git',
         web => 'https://github.com/voegelas/nginx-auth-saslauthd',
       },
    },
  }
}


my %FallbackPrereqs = (
  "IO::Socket::Timeout" => 0,
  "IO::Socket::UNIX" => 0,
  "Mojolicious" => 0,
  "File::Spec" => 0,
  "File::Temp" => 0,
  "List::Util" => 0,
  "Test::More" => "0.96"
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.63_03) } ) {
  delete $WriteMakefileArgs{TEST_REQUIRES};
  delete $WriteMakefileArgs{BUILD_REQUIRES};
  $WriteMakefileArgs{PREREQ_PM} = \%FallbackPrereqs;
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);
