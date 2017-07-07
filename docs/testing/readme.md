# Setup short way
0. install dependency ppas
    - `sudo add-apt-repository ppa:openhie/datim-testing && sudo add-apt-repository ppa:certbot/certbot && sudo apt-get update`
1. install `datim4u-auto-cert-updater`
    - `sudo apt-get install datim4u-auto-cert-updater`
2. install dependencies 
    - `sudo apt-get install -f`
    - note, this will include configuring `openhim-cert-updater`. 
        - you will have to find where the cert and privkey for openhim / from certbot are stored 
            - on ls.datim4u.org this is located at 
                - cert : `/etc/letsencrypt/live/ls.datim4u.org/fullchain.pem`
                - key : `/etc/letsencrypt/live/ls.datim4u.org/privkey.pem`
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
        - if you mess up durring the configuration process, start over by calling the config CLI again w/ `openhim-cert-updater -c`

3. ensure that all has been installed correctly
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
    2. `sudo openhim-cert-updater` should not show any errors
        - this checks that the `openhim-cert-updater` installation and configuration suceeded
    3. `sudo -H -u datim4u_auto_cert_updater /usr/share/datim4u-auto-cert-updater/check_for_renewal.sh` should not show any errors

# Test
Once you are confident that openhim-cert-updater is setup correctly (running `sudo openhim-cert-updater` is a good way of evaluating this) we need to ensure 3 things:
1. the certbot command is successfuly able to renew the certificate
    - `sudo certbot renew --renew-hook "openhim-cert-updater" -n --dry-run --force-renew`