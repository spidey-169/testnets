# Setup environment

Install environment for Celestia-APPD

```
wget https://raw.githubusercontent.com/spidey-169/testnets/main/celestia_network/celestia_tools/celestia_validator_set_env.sh \
&& chmod +x celestia_validator_set_env.sh \
&& ./celestia_validator_set_env.sh 
```


# Node setup/Cosmovisor Installation and Snapshot based installation

For Celestia Validator installation (Celestia-APPD):


```
GIT_NAME=celestiaorg
GIT_FOLDER=celestia-app
BIN_NAME=celestia-appd
CONFIG_FOLDER=celestia-app
BIN_VER=v0.13.0

wget https://raw.githubusercontent.com/spidey-169/testnets/main/celestia_network/celestia_tools/celestia_validator_installer.sh \
&& chmod +x celestia_validator_installer.sh \
&& ./celestia_validator_installer.sh -g $GIT_NAME -f $GIT_FOLDER -b $BIN_NAME -c $CONFIG_FOLDER -v $BIN_VER
```

Note the additional network parameters which will be asked during installation:

Celestia chain-id : 
```
blockspacerace-0
```

Genesis file link:
```
https://raw.githubusercontent.com/celestiaorg/networks/master/blockspacerace/genesis.json
```

PEERS (https://github.com/celestiaorg/networks/blob/master/blockspacerace/peers.txt)
```
be935b5942fd13c739983a53416006c83837a4d2@178.170.47.171:26656
```
SEEDS (https://github.com/celestiaorg/networks/blob/master/blockspacerace/seeds.txt)
```
0293f2cf7184da95bc6ea6ff31c7e97578b9c7ff@65.109.106.95:26656
```

# Launch node

## Reload configuration change 

```
systemctl daemon-reload
```
## Restart Cosmovisor service 

```
systemctl restart celestia-appd.service
```
## Cosmovisor service logs 

```
journalctl -u celestia-appd.service -f
```
## Stop Cosmovisor service 

```
systemctl stop celestia-appd.service
```
