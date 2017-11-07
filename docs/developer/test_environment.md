Note: this file is "under construction". It should contain instructions on setting up a testing box for certificate testing, mimicking the setup we would find on the datim box.


### Install the Datim4u stack - excluding open imfo man, mech, and etc
- `sudo add-apt-repository -y ppa:openhie/datim-testing && sudo apt-get update && sudo apt-get install datim4u-ohie`
- `sudo /usr/share/datim4u-ohie/install.sh --skip-mech --skip-oim --skip-etc`
    - use flag `--use-test-input` if you know the values to input already
        - update the test input values:
            - `sudo nano /usr/share/datim4u-ohie/install.sh`
        - enable execution of newly "sudoed" file
            - `sudo chmod +x /usr/share/datim4u-ohie/install.sh`
        - run install w/ test input
            - `sudo /usr/share/datim4u-ohie/install.sh --use-test-input --skip-mech --skip-oim --skip-etc`

### for installing the package in test environment, see `readme.md` under packaging
