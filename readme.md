This repository stores a package, specificly built for the datim system, to automatically manage certificate renewal.

# Overview
The package:
1. creates a cronjob that tracks and implements certificate renewal
2. upon certificate renewal, automates informing all required software of the updates
    - the `openhim-cert-updater` is used for part of this



# Environment Check
Ensure environment is set up correctly
1.  `cat /etc/nginx/sites-available/datim` should display the following at the top:
    ```
    server{
        listen 80;
        location /.well-known {
            root /usr/share/nginx/html;
        }
        location / {
            return 301 https://$host$request_uri;
        }
    }
    ```
    - if it does not, the `nginx-datim` package is not up to date.
3. Please make sure that nginx will look for certificates in the location that letsencrypt will place them. `cat /etc/nginx/sites-available/datim` should contain something similar to the following, where `HOST_NAME` is replaced with the DNS name of the server:
    ```
    listen 443 ssl;
	## SSL config Options
	# Replace the follwing two lines with the path to your ssl certificate and key
	ssl_certificate /etc/letsencrypt/live/HOST_NAME/fullchain.pem;
	ssl_certificate_key /etc/letsencrypt/live/HOST_NAME/privkey.pem;
    ```
2. check to make sure that updating client certificates manually does not cause errors
    - per issue https://github.com/pepfar-datim/DATIM4U/issues/457
    - see comments for work-arounds if this scenario exists


# Installation
#### From PPA
0. install dependency ppas
    - `sudo add-apt-repository ppa:openhie/datim && sudo add-apt-repository ppa:certbot/certbot && sudo apt-get update`
1. install `datim-auto-cert-updater`
    - `sudo apt-get install datim-auto-cert-updater`
2. install dependencies
    - `sudo apt-get install -f`

#### From Source
0. Download `.deb` files
    - `wget https://github.com/uladkasach/openhim-cert-updater/releases/download/v1.2.9/openhim-cert-updater_1.2.9.trusty_amd64.deb`
    - `wget https://github.com/OHIEDATIM/datim-auto-cert-updater/releases/download/v1.1.4/datim-auto-cert-updater_1.1.4.trusty_amd64.deb`
1. Install deb files
    - `sudo dpkg -i openhim-cert-updater_1.2.9.trusty_amd64.deb`
    - `sudo dpkg -i datim-auto-cert-updater_1.1.4.trusty_amd64.deb`
        - it may give you a warning that dependencies are not installed, the next step takes care of this
3. Install further dependencies
    - `sudo apt-get install -f`

# Configuration
3. create users for `openhim-cert-updater` on local and remote machines
    - we need credentials which will enable this utility to gain authorized access to the openhim apis on both the local and remote machines
        - This can be completed under the users tab of an openhim client interface
3. configure `openhim-cert-updater`
    - run `openhim-cert-updater -c` for details
    - run `openhim-cert-updater -c -o` and modify the configuration file
    - example configuration
        ```
        {
            "paths": {
                "cert": "/etc/letsencrypt/live/ls.datim4u.org/fullchain.pem",
                "key": "/etc/letsencrypt/live/ls.datim4u.org/privkey.pem"
            },
            "machines": {
                "local": "localhost:5008",
                "remote": [
                    "test2-global-ohie.datim.org:5008"
                ]
            },
            "clients":{
                "localhost:5008" : [],
                "test2-global-ohie.datim.org:5008" : ["lsohiestack"]
            },
            "users": {
                "localhost:5008": {
                    "email": email_for_cert_updater_user_on_ls,
                    "password": password_for_cert_updater_user_on_ls
                },
                "test2-global-ohie.datim.org:5008": {
                    "email": email_for_cert_updater_user_on_test2,
                    "password": password_for_cert_updater_user_on_test2
                }
            }
        }
        ```

# Test Setup
ensure that all has been installed correctly
0. running `sudo su openhim_cert_updater -c "sudo openhim-cert-updater"` (or `sudo su openhim_cert_updater` and then `sudo openhim-cert-updater` and then `exit`) should not show any errors
    - this checks that the `openhim-cert-updater` installation and configuration suceeded
    - note, if an error displays along the lines of `Error: ENOENT: no such file or directory, open '/etc/ssl/certs/ohim-selfsigned.crt'`, ensure that there exists a certificate at the path.
1. the `openhim_cert_updater` user should be able to successfuly run the `check for renewal command`
    - `sudo su openhim_cert_updater -c "/usr/share/datim-auto-cert-updater/check_for_renewal.sh"` should not show any errors
        - additionally, you should find a log entry for the run under `/home/openhim_cert_updater/`
             - `cat /home/openhim_cert_updater/run.log`
2. certbot should be able to successfully conduct a dry run
    - `sudo su openhim_cert_updater -c "/usr/share/datim-auto-cert-updater/check_for_renewal.sh --dry-run"`
3. openhim-cert-updater user should be able to restart nginx and mediators successfully
    - `sudo su openhim_cert_updater -c "/usr/share/datim-auto-cert-updater/restart_dependencies_post_update.sh"` should succeed

# Test Cert Renewal
ensure that when certificate is updated, local machine and all relevant remote machines are updated
0. ensure that `watchFSforCert` is disabled
    - check the config file `/etc/openhim/config.json` and ensure `"watchFSForCert": false,`
        - `sudo nano /etc/openhim/config.json`
    - if you needed to modify the default value, you must now restart openhim-core
        - `sudo restart openhim-core`
1. force certificate update
    - `sudo certbot renew -n --force-renew`
    - this command should return a sucessful response
2. manually trigger openhim-cert-updater
    - `sudo su openhim_cert_updater -c "/usr/share/datim-auto-cert-updater/update_dependencies_post_renewal.sh"`
        - this command should respond stating that the local machine and all remote machines were updated and that nginx was restarted
        - if certs were not equal, it will have also run the hook
        - check the logs to ensure all was sucessful
            - `cat /home/openhim_cert_updater/run.log`
3. manually check openhim machines, through openhim-console, to ensure that:
    - certificates were indeed updated
        - compare the begin and end time on the local and remote machines
    - clients were indeed updated
        - ensure that remote clients reference the correct certificate

# Test Cronjob
This will entail reading logs and waiting untill 30 days untill expiration date of the next certificate
The two following log files will contain timestamps for when the certificate renewal command was run and for when the openhim-cert-updater command was run:
- cat renewal check log : `cat /home/openhim_cert_updater/run.log`
- cat openhim-cert-updater log : `cat /usr/share/openhim-cert-updater/run.log`

The renewal check log should produce a timestamp at the interval defined by the cronjob. Every time the cron task is run, a timestamp will be generated here. The `openhim-cert-updater` log should produce a timestamp only when it has been triggered by a certificate update (from the `certbot --renewal-hook`) (or when a user manually caslls `openhim-cert-updater -r`) (if the file does not exist, that means `openhim-cert-updater -r` has not been run, i.e., a certificate renewal has not been triggered )

Summary:
- ensure that there is a timestamp in `/home/openhim_cert_updater/run.log` at the cronjob intervals
     - `cat /home/openhim_cert_updater/run.log`
- ensure that there is a timestamp in `/usr/share/openhim-cert-updater/run.log` for when the certificate would have been renewed (30 days before expiration date)
    - `cat /usr/share/openhim-cert-updater/run.log`
