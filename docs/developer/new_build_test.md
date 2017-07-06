1. first install certbot setup

2. install openhim-cert-updater from datim-testing
    -  `sudo add-apt-repository ppa:openhie/datim-testing && sudo apt-get update && sudo apt-get install openhim-cert-updater;`
    
3. install your dpkg for latest build
    - `dpkg -i ...`
    
    
    
### If using vagrant

- add cert_work root directory
    - `export CERTDIR=/var/www/Regenstrief/OHIE/certificate_renewal;`
- build the pacakge
    - set GPG keys
        - e.g., `export DEB_SIGN_KEYID=F516F2E7`
    - `cd $CERTDIR/datim4u-auto-cert-updater/packaging/; ./create_deb.sh;`
        - say no when asking if to put to launchpad
- move to vagrant
    - `cd $CERTDIR/ohim/core; rm *.deb; find $CERTDIR/datim4u-auto-cert-updater/packaging/builds -name "*.deb" -print0 | xargs --null cp -t $CERTDIR/ohim/core`
- build it on the vagrant 
    - `cd $CERTDIR/ohim/core; vagrant ssh`
    - `sudo apt-get -y remove datim4u-auto-cert-updater`
    - `find /vagrant -name "*.deb" -print0 | xargs --null  sudo dpkg -i; `
    - `sudo apt-get install -f`
        