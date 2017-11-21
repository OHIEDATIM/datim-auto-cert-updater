#!/bin/bash
## check if the certificate is expiring soon and renew it if needed
sudo echo "a check was run $(date)">> ~/run.log

if [[ "$1" == "--dry-run" ]]; then
    sudo certbot renew --renew-hook "/usr/share/datim-auto-cert-updater/update_dependencies_post_renewal.sh" -n --dry-run
            # -n ensures a noninteractive session
            # --renew-hook command only fires if a certificate is renewed
else
    sudo certbot renew --renew-hook "/usr/share/datim-auto-cert-updater/update_dependencies_post_renewal.sh" -n
fi

exit 0
