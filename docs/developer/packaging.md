### Build it

- add cert_work root directory
    - `export CERTDIR=/var/www/Regenstrief/OHIE/certificate_renewal;`
- build the pacakge
    - set GPG keys if sending to launchpad
        - e.g., `export DEB_SIGN_KEYID=F516F2E7`
    - `cd $CERTDIR/datim4u-auto-cert-updater/packaging/; ./create_deb.sh;`
        
        
### If using vagrant to test

- move to vagrant
    - `cd $CERTDIR/ohim/core; rm *.deb; find $CERTDIR/datim4u-auto-cert-updater/packaging/builds -name "*.deb" -print0 | xargs --null cp -t $CERTDIR/ohim/core`
- build it on the vagrant 
    - `cd $CERTDIR/ohim/core; vagrant ssh`
    - `sudo apt-get -y remove datim4u-auto-cert-updater`
    - `find /vagrant -name "*.deb" -print0 | xargs --null  sudo dpkg -i; `
    - `sudo apt-get install -f`
        