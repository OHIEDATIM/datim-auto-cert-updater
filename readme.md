This repository stores a package, specificly built for the datim4u system, to automatically manage certificate renewal.

The package does two things:
1. Setup a cronjob that automatically renews the certificates (when they are about to expire) for the datim4u openhie system and triggers a certificate updater program
    - `certbot renew` is utilized to renew the certificate, ensure that it is only renewed when it is getting ready to expire, and to trigger a command upon renewal
2. Setup the certificate updater program that the renewal will trigger
    - `openhim-cert-updater` package
    
Please see [/docs/testing/readme.md](https://github.com/OHIEDATIM/datim4u-auto-cert-updater/blob/master/docs/testing/readme.md) for more info.