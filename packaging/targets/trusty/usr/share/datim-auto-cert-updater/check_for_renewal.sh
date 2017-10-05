#!/bin/bash
## check if the certificate is expiring soon and renew it if needed
sudo echo "a check was run $(date)">> ~/run.log
sudo certbot renew --renew-hook "sudo -H -u openhim_cert_updater sudo openhim-cert-updater -r" -n
        # -n ensures a noninteractive session
        # --renew-hook command only fires if a certificate is renewed
exit 0