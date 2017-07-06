To setup the package to test one needs to do three things:
1. Install `openhim-cert-updater` dependencies
    - add dependent ppa
        - `sudo add-apt-repository ppa:openhie/datim-testing; sudo apt-get update;`
    - update the current version of nginx-datim
        - `sudo apt-get install --only-upgrade nginx-datim`
        - `cat /etc/nginx/sites-available/datim` should display the following at the top:
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
    - ensure new certbot package is installed  
        - `sudo apt-get install -y software-properties-common && sudo add-apt-repository ppa:certbot/certbot && sudo apt-get update && sudo apt-get install -y python-certbot-nginx`
    - note - `openhim-core` should already be installed on this machine
2. Install and configure `openhim-cert-updater`
    - `sudo apt-get install openhim-cert-updater`
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
    - if you mess up durring the configuration process, start over by calling the config CLI again w/ 
        - `openhim-cert-updater -c`
    - test installation by running `sudo openhim-cert-updater`.
        - note, you should see the updater inform you that all is already up to date.
3. Install `datim4u-auto-cert-updater`

...