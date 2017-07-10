## Usage 
0. Ensure your DEBFULLNAME and DEBEMAIL are defined
    - in your `~/.bashrc` you should have the following commands
        - `export DEBFULLNAME=<yourname>`
        - `export DEBEMAIL=<youremail>`
    - this information will be used to populate the changelog

0. To build the package to test:
    - `./create_deb`

0. To build the package and push to launchpad
    1. set the GPG key to use
        - e.g., `export DEB_SIGN_KEYID=F516F2E7`
    2. `./create_deb`
    
## Details

This script expects the directory structure of, assuming root is where this script is located,:


    targets/trusty/...
                  /debian
                  /<others>
                  
Where trusty can be anay ubuntu build, the `debian` directory contains the regular files required for a debian build, and `<others>` are all files that you would expect to "install" on the target system.
