# nginx-auth-saslauthd

This nginx utility verifies web users with Basic authentication and saslauthd.
Authentication requests are forwarded from nginx to this program with
[auth_request](https://nginx.org/en/docs/http/ngx_http_auth_request_module.html).

```Nginx
location /private {
    auth_request /auth-basic;
}

location = /auth-basic {
    proxy_pass http://127.0.0.1:8888;
    proxy_pass_request_body off;
    proxy_set_header Content-Length "";
    proxy_set_header X-Realm "Restricted";
    proxy_set_header X-Saslauthd-Path "/var/run/saslauthd/mux";
}
```

## INSTALLATION

To install the program, run the following commands:

```Shell
perl Makefile.PL
make
make install
```

## DEPENDENCIES

This program requires [Mojolicious](http://mojolicious.org/),
IO::Socket::Timeout and the saslauthd daemon from Cyrus SASL.

On Ubuntu, install the packages libmojolicious-perl, libio-socket-timeout-perl
and sasl2-bin.

## SUPPORT AND DOCUMENTATION

Type "man nginx-auth-saslauthd" after installation to see the program usage
information.

If you want to hack on the source it might be a good idea to install
[Dist::Zilla](http://dzil.org/) and grab the latest version with git using the
command:

```Shell
git clone https://github.com/voegelas/nginx-auth-saslauthd.git
```

## LICENSE AND COPYRIGHT

Copyright 2017 Andreas Vögele

This program is free software; you can redistribute it and/or modify it under
the terms of the ISC license.
