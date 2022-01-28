# nginx-auth-saslauthd

This [nginx](https://nginx.org/) utility verifies web users with Basic
authentication and LDAP, PAM or other mechanisms supported by saslauthd.
Authentication requests are forwarded from nginx with the
[auth_request](https://nginx.org/en/docs/http/ngx_http_auth_request_module.html)
directive.

    location /private/ {
        auth_request /auth;
    }

    location = /auth {
        internal;
        proxy_pass http://unix:/run/nginx-auth/saslauthd.sock:/auth-basic;
        proxy_pass_request_body off;
        proxy_set_header Content-Length "";
        proxy_set_header X-Realm "Restricted";
    }

## DEPENDENCIES

This program requires [Mojolicious](https://mojolicious.org/) 7.27 or later and
the saslauthd daemon from Cyrus SASL.

## INSTALLATION

Run the following commands to install the software:

    perl Makefile.PL INSTALLSITESCRIPT=/usr/local/sbin \
        INSTALLSITEMAN1DIR=/usr/local/share/man/man8 MAN1EXT=8
    make MAN1SECTION=8
    make test
    make install

Type the following command to see the program usage information:

    man nginx-auth-saslauthd

## LICENSE AND COPYRIGHT

Copyright 2017-2022 Andreas Vögele

This program is free software; you can redistribute and modify it under the
terms of the ISC license.
