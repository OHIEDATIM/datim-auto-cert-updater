#!/bin/bash
## check if the certificate is expiring soon and renew it if needed
sudo certbot renew --renew-hook "openhim-cert-updater" -n
        # -n ensures a noninteractive session
        # --renew-hook command only fires if a certificate is renewed
exit 0