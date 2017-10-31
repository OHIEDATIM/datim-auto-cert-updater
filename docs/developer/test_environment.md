Note: this file is "under construction". It should contain instructions on setting up a testing box for certificate testing, mimicking the setup we would find on the datim box.


### Install the Datim4u stack - excluding open imfo man, mech, and etc
- `sudo add-apt-repository -y ppa:openhie/datim-testing`
- `install-datim4u-ohie --skip-mech --skip-oim --skip-etc`
    - use flag `--use-test-input` if you're copying the raw script over and have defined the default options for your configuration already

### for installing the package in test environment, see `readme.md` under packaging
