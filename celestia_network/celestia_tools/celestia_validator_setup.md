# Setup environment

Install environment for Celestia with a userflag for custom version of Golang #GO.

Specify version and GO path in this line ./go.sh -v GO_VERSION -p GO_PATH
Example ./go.sh -v 1.20.2 -p /root/go

You can use all the variables or not use them at all and then the GO_VERSION and GO_PATH will be used by default as (-v 1.20.2 -p /usr/local/go)

```
wget https://raw.githubusercontent.com/spidey-169/testnets/main/celestia_network/celestia_tools/celestia_validator_set_env.sh \
&& chmod +x celestia_validator_set_env.sh \
&& ./celestia_validator_set_env.sh -v 1.20.2 -p /root/go \
&& rm -rf go.sh
```


# Node setup/Cosmovisor Installation and Snapshot based installation

For Celestia Validator installation: provide the following command line arguments

GIT_NAME=celestiaorg
GIT_FOLDER=celestia-app
BIN_NAME=celestia-appd
CONFIG_FOLDER=.celestia-app
BIN_VER=v0.13.0

```
wget https://raw.githubusercontent.com/spidey-169/testnets/main/celestia_network/celestia_tools/celestia_validator_installer.sh \
&& chmod +x celestia_validator_installer.sh \
&& ./celestia_validator_installer.sh -g GIT_NAME -f GIT_FOLDER -b BIN_NAME -c CONFIG_FOLDER -v BIN_VER
```

# Launch node

Reload configuration change 
    - systemctl daemon-reload
Restart Cosmovisor service 
    - systemctl restart celestia-appd.service
Cosmovisor service logs 
    - journalctl -u celestia-appd.service -f
Stop Cosmovisor service 
    - systemctl stop celestia-appd.service
