# nginx-auth-saslauthd

This nginx utility verifies web users with Basic authentication and LDAP, PAM
or other mechanisms supported by saslauthd. Authentication requests are
forwarded from nginx with the
[auth_request](https://nginx.org/en/docs/http/ngx_http_auth_request_module.html)
directive.

```Nginx
location /private/ {
    auth_request /auth;
}

location = /auth {
    internal;
    proxy_pass http://unix:/run/nginx-auth/http.sock:/auth-basic;
    proxy_pass_request_body off;
    proxy_set_header Content-Length "";
    proxy_set_header X-Realm "Restricted";
}
```

## INSTALLATION

To install the program, run the following commands:

```
perl Makefile.PL
make
make test
make install
```

## DEPENDENCIES

This program requires [Mojolicious](http://mojolicious.org/) 8.0 or later and
the saslauthd daemon from Cyrus SASL.

## SUPPORT AND DOCUMENTATION

Type "man nginx-auth-saslauthd" after installation to see the program usage
information.

If you want to hack on the source, grab the latest version using the command:

```
git clone https://gitlab.com/voegelas/nginx-auth-saslauthd.git
```

## LICENSE AND COPYRIGHT

Copyright 2017-2021 Andreas Vögele

This program is free software; you can redistribute and modify it under the
terms of the ISC license.
