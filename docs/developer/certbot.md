Note: this file is "under construction". It should contain instructions on setting up a testing box for certificate testing, mimicking the setup we would find on the datim box.

Dev box setup
1. Ensure that machine is addressable publicly
    - e.g., cert.test.ohie.org 
    - `PUBLICDNSDOMAIN="cert.test.ohie.org"`
2. Update and install nginx and configure it like we would find on a real box
    - `sudo add-apt-repository ppa:openhie/datim-testing && sudo apt-get update && apt-get install -y nginx-datim`
3. Update and install certbot
    - ` sudo apt-get install -y software-properties-common && sudo add-apt-repository ppa:certbot/certbot && sudo apt-get update && sudo apt-get install -y python-certbot-nginx`
4. Receive a certificate
    - `certbot certonly --webroot -w /usr/share/nginx/html -d $PUBLICDNSDOMAIN`
5. Test renewal
    - `certbot renew --renew-hook "echo SCS" -n --dry-run`