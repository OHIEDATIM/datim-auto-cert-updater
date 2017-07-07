
# Setup Long way
1. Install `openhim-cert-updater` dependencies
    - add dependent ppa
        - `sudo add-apt-repository ppa:openhie/datim-testing; sudo apt-get update;`
    - update the current version of nginx-datim
        - `sudo apt-get install nginx-datim`
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