#!/bin/bash
# this file should be called after local openhim-core is updated with new certificate
# currently, this script is called with a "hook" on the openhim-cert-updater functionality in update_openhim_post_renewal.sh
sudo echo " - openhim-cert-updater hook triggered">> ~/run.log

############################
## Restart mediators
############################
sudo echo "     - restarting mediators... ">> ~/run.log
sudo restart openhim-mediator-datim
sudo restart openhim-mediator-file-queue
sudo restart openhim-mediator-openinfoman-dhis2-sync
sudo restart openhim-mediator-shell-script


###########################
## Reload nginx
###########################
# reload nginx to ensure that nginx uses the updated certificate
# restart nginx after updating openhim-cert-updater in order to ensure that the openhim-cert-updater is not interupted
sudo echo "     - restarting nginx... ">> ~/run.log
sudo /etc/init.d/nginx reload
