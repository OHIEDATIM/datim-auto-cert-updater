# Setup
0. install dependency ppas
    - `sudo add-apt-repository ppa:openhie/datim && sudo add-apt-repository ppa:certbot/certbot && sudo apt-get update`
1. install `datim-auto-cert-updater`
    - `sudo apt-get install datim-auto-cert-updater`
2. install dependencies
    - `sudo apt-get install -f`
    - note, this will include configuring `openhim-cert-updater`.
        - you will have to find where the cert and privkey for openhim / from certbot are stored
            - on ls.datim4u.org this is located at
                - cert : `/etc/letsencrypt/live/ls.datim4u.org/fullchain.pem`
                - key : `/etc/letsencrypt/live/ls.datim4u.org/privkey.pem`
            - on cert.test.ohie.org this is located at
                - cert : `/etc/letsencrypt/live/cert.test.ohie.org/fullchain.pem`
                - key : `/etc/letsencrypt/live/cert.test.ohie.org/privkey.pem`
            - on a machine w/ certs created by `sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/ohim-selfsigned.key -out /etc/ssl/certs/ohim-selfsigned.crt`
                - cert : `/etc/ssl/certs/ohim-selfsigned.crt`
                - key : `/etc/ssl/private/ohim-selfsigned.key`
        - you will have to know the localhost path and authentication information (email and password) for a user w/ permissions to update the certificate on the local machine
            - on a default installation:
                - host : `localhost:8080`
                - root user  
                    - email : `root@openhim.org`
                    - password : `openhim-password`
        - you will have to know the path and authentication information for similar user on relevant remote machines, if you want them to be "informed" on the update
        - if you mess up durring the configuration process, start over by calling the config CLI again w/ `sudo su openhim_cert_updater -c "openhim-cert-updater -c"` (or `sudo su openhim_cert_updater` and then `sudo openhim-cert-updater -c` and then `exit`)
        - to review the configuration file, run `sudo su openhim_cert_updater -c "openhim-cert-updater -c -m"`

# Test Setup
ensure that all has been installed correctly
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
2. running `sudo su openhim_cert_updater -c "openhim-cert-updater"` (or `sudo su openhim_cert_updater` and then `sudo openhim-cert-updater` and then `exit`) should not show any errors
    - this checks that the `openhim-cert-updater` installation and configuration suceeded
    - note, if an error displays along the lines of `Error: ENOENT: no such file or directory, open '/etc/ssl/certs/ohim-selfsigned.crt'`, ensure that there exists a certificate at the path.
3. the `openhim_cert_updater` user should be able to successfuly run the `check for renewal command`
    - `sudo su openhim_cert_updater -c "/usr/share/datim-auto-cert-updater/check_for_renewal.sh"` should not show any errors
        - additionally, you should find a log entry for the run under `/home/openhim_cert_updater/`
             - `cat /home/openhim_cert_updater/run.log`
4. certbot should be able to successfully conduct a dry run
    - `sudo su openhim_cert_updater -c "/usr/share/datim-auto-cert-updater/check_for_renewal.sh --dry-run"`
5. openhim-cert-updater user should be able to restart nginx and mediators successfully
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
3. manually check openhim machines, through openhim-console, to ensure that certificates were indeed updated

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
