#!/bin/bash
## run openhim-cert-updater upon letsencrypt successfuly renewing certificate for machine
# currently, this script is called with a "hook" on the openhim-cert-updater functionality in check_for_renewal.sh
sudo echo " - certificate renewal hook triggered, running openhim-cert-updater... ">> ~/run.log
sudo openhim-cert-updater -l -h '/usr/share/datim-auto-cert-updater/restart_dependencies_post_update.sh'
        # -l ensures that openhim-cert-updater logs its ongoings
        # -h defines the hook to run after updating the local openhim's certificate
exit 0
