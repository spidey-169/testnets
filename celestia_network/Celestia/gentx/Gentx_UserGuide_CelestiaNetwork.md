#  README GENTX Celestia Network

## Create a new user account on the dedicated server

## [ADD NEW USER FROM ROOT](../add_new_user_on_server.md)

<!-- ## Create a new user account on the dedicated server

 If you are signed in as the root user, you can create a new user at any time by running the following:

```
adduser spidey

```

 Grant the user sudo privileges

```
usermod -aG sudo spidey

```

 Check if the new user has sudo as one of the groups

```
groups spidey
``` -->

## Setup The Dependencies

First, make sure to update and upgrade the OS:

```
sudo apt update && sudo apt upgrade -y

```

These are essential packages that are necessary to execute many tasks like downloading files, compiling and monitoring the node:

```
sudo apt install curl tar wget clang pkg-config libssl-dev jq build-essential git make ncdu -y

```


Install Golang

```
ver="1.21.1"
cd $HOME 
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz" 
sudo rm -rf /usr/local/go 
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz" 
rm "go$ver.linux-amd64.tar.gz" 
```

Now we need to add the /usr/local/go/bin directory to $PATH:

```
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> $HOME/.bash_profile
source $HOME/.bash_profile
```

To check if Go was installed correctly run:

```
go version

```

## Install Celestia App
The steps below will create a binary file named celestia-appd inside $HOME/go/bin folder which will be used later to run the node.

```
cd $HOME
rm -rf celestia-app
git clone https://github.com/celestiaorg/celestia-app.git
cd celestia-app/
APP_VERSION=v1.1.0
git checkout tags/$APP_VERSION -b $APP_VERSION
make install
```

To check if the binary was successfully compiled you can run the binary using the --help flag:

```
celestia-appd --help

```

## Init node (Celestia network, --chain-id: celestia)

You can first run the following commands:

```
VALIDATOR_NAME=spidey
CHAIN_ID=celestia
celestia-appd init $VALIDATOR_NAME --chain-id $CHAIN_ID
```

You should an output something like this

```
{"app_message":{"auth":{"accounts":[],"params":{"max_memo_characters":"256","sig_verify_cost_ed25519":"590","sig_verify_cost_secp256k1":"1000","tx_sig_limit":"7","tx_size_cost_per_byte":"10"}},"bank":{"balances":[],"denom_metadata":
xxxxxxxxxxxx
xxxxxxxxxxxx
```

## Assign a Moniker and EVM_ADDRESS

```
MONIKER=spidey
```

NO NEED to assign an EVM_ADDRESS at this time for celestia network
<!-- %EVM_ADDRESS=<YOUR_ETH_ADDRESS_GOES_HERE> -->


## Create wallet or recover one

Refer userguide for more wallet details

## [Celestia Wallet Setup and Useful Commands Guide](../wallets_userguide.md)

### Option 1 - generate new wallet

DON"T USE THIS STEP for GENTX for Celestia as your wallet info should already be submitted. (since already added to genesis.json)

<!-- ```
celestia-appd config keyring-backend test
```


```
KEY_NAME=validator
celestia-appd keys add $KEY_NAME
```

Sample output

```
- address: celestia1q4qtpgw9m6l4ezj6v0pc7l79eq7fpd83c9hnjq
  name: validator
  xxxxx
  xxxxx
```


Copy the wallet seed phrase and keep in secure place

Another IMPORTANT but optional action is backup your Validator_priv_key:

```
tar -czvf validator_key.tar.gz .celestia-app/config/*_key.json
gpg -o validator_key.tar.gz.gpg -ca validator_key.tar.gz
rm validator_key.tar.gz
```  -->

### Option 2 - recover existing wallet

USE THIS WALLET since you already submitted a wallet information during blockspacerace and your wallet is already in genesis.json

```
KEY_NAME=validator-mainnet
celestia-appd keys add $KEY_NAME --recover
```

<!-- ## Add genesis account -->

<!-- NO NEED for this step, since the genesis.json file already contains the balance for the address -->

<!-- ```
CELES_AMOUNT="8000000utia"
celestia-appd add-genesis-account $KEY_NAME $CELES_AMOUNT
``` -->


## IMPORTANT (DON't SKIP )Manage Ports/Firewall

Please refer to the guide to manage listening port and external address as well as firewall when using proxmox guest node or dedicated isolated nodes for validator/bridge/fullnode

## [PORTS_FIREWALL_SETTINGS](../ports_firewall_settings.md)

<!-- ## MANAGE PORTS (IMPORTANT) (Config.toml file edits) 

Add your public IP, port information to the list of external address and also configure laddr ports

### 1.  Default Listening address/port (P2P) for p2p connection (26656) in config.toml, 

Check/Modify default LISTENING port 26656 for p2p connection if setting validator on guest proxmox node

(a) You can keep this address to be the default address 26656, if using a dedicated node and no conflict between ports (fresh cloud node without anything else running on it now or in future). This is good choice if you have a separate node hosted on a separate server and port 26656 will not be in conflict.

Hence in config.toml I will keep under P2P configuration to be default

```
laddr = 0:0:0:0:26656
```
```
#######################################################
###           P2P Configuration Options             ###
#######################################################
[p2p]

# Address to listen for incoming connections
laddr = "tcp://0.0.0.0:26656"
```

(b) If you wish to install validator/fullnode as a guest node (proxmox guest), you can edit the default LISTENING p2p port for validator/fullnode from 26656 be 26603 (in case 26656 is taken). This is desirable say if you want multiple testnets of celestia, to be run as different guest nodes and all need access to 26656. This changes the default port for listening for p2p connection for validator from 26656 to 26603. This is important if you are using say a proxmox guest node for validator and using natting to map ports from guest to host node. Here note that you will also need to setup natting from guest port 26603 to Host port 26603. If you have firewall, you need to open 26603 port in firewall.


Hence in config.toml I will change under P2P configuration

```
laddr = 0:0:0:0:26603
```

This will change the entry to something like this

```
#######################################################
###           P2P Configuration Options             ###
#######################################################
[p2p]

# Address to listen for incoming connections
laddr = "tcp://0.0.0.0:26603"
```

### 2.  EXTERNAL address (P2P), Add HOST IP/Public IP to the list of external address in config.toml, this is essential for outgoing connections.

Here I will add my HOST_IP and port to external_address under P2P configuration

(a) In case of hosting on a separate dedicated node, use PUBLIC IP (one from -ifconfig) and port same as p2p port 

```
external_address=<PUBLIC_IP>:26656
```

When both of these are setup it will look like below:

```
#######################################################
###           P2P Configuration Options             ###
#######################################################
[p2p]

# Address to listen for incoming connections
laddr = "tcp://0.0.0.0:26656"

# Address to advertise to peers for them to dial
# If empty, will use the same port as the laddr,
# and will introspect on the listener or use UPnP
# to figure out the address. ip and port are required
# example: 159.89.10.97:26656

external_address = "<YOUR_HOST_IP>:26656"
```

(b) In case of hosting on a guest proxmox node use this as the HOST_IP (ip corresponding to host of proxmox server which is also the public IP address) and port same as default LISTENING p2p port chosen (26603 chosen before)


```
external_address=<YOUR_HOST_IP>:26603
```

When both of these are setup it will look like below:

```
#######################################################
###           P2P Configuration Options             ###
#######################################################
[p2p]

# Address to listen for incoming connections
laddr = "tcp://0.0.0.0:26603"

# Address to advertise to peers for them to dial
# If empty, will use the same port as the laddr,
# and will introspect on the listener or use UPnP
# to figure out the address. ip and port are required
# example: 159.89.10.97:26656

external_address = "<PROXMOX_HOST_IP>:26603"
```

### 3.  LISTENING address for RPC. If you are going to run a bridge node and need to connect it to validator/fullnode, you also need to allow port 26657 (default rpc port) from your validator/fullnode node to be able to accessed by your bridge node.

You can do this by setting laddr in RPC SERVER CONNECTIONs as 

```
laddr = 0:0:0:0:26657

```

This will change the setting as follows:
```
#######################################################################
###                 Advanced Configuration Options                  ###
#######################################################################

#######################################################
###       RPC Server Configuration Options          ###
#######################################################
[rpc]

# TCP or UNIX socket address for the RPC server to listen on
laddr = "tcp://0.0.0.0:26657"
```

REMEMBER, if FIREWALL is ENABLED, you need to allow BRIDGE NODE IP to be able to access FullNode/Validator NODE port 26657 (See Firewall rules below)

## FIREWALL: Setting up firewall when hosting validator on proxmox guest node/ vs separate server node (one can use ufw too)

Proxmox firewall configurations only allow to proxmox instance
### 1.  OPEN SSH port 22 on guest node 

Settings for Proxmox firewall (via GUI interface):
Here DESTINATION port (D.Port) is 22, interface: net0, Protocol: tcp, ACTION: accept, TYPE:in

Setting for ufw:
sudo ufw allow ssh

### (2a) OPEN DEFAULT listening port for p2p connection, 26656 
Settings for ufw:
sudo ufw allow 26656

OR

### (2b) PROXMOX GUEST NODE only, OPEN user specified listening port for p2p connection (set above), 26603 on guest node (when P2P default port has been changed)

Settings for Proxmox firewall (via GUI interface):
Here DESTINATION port (D.Port) is 26603, interface: net0, Protocol: tcp, ACTION: accept, TYPE:in

Settings for ufw:
sudo ufw allow 26603

###  3. OPEN listening port p2p connection, 26603 on host node (if firewall enabled on host)

###  4. (IMPORTANT IF BRIDGE NODE IS CONNECTING TO THIS VALIDATOR/FULLNODE) OPEN RPC listening port 26657 ONLY to bridge node IP (SOURCE)
Settings for Proxmox firewall (via GUI interface):
Here DESTINATION port (D.Port) is 26657, SOURCE: <BRIDGE_NODE_IP> interface: net0, Protocol: tcp, ACTION: accept, TYPE:in

You can also connect bridge node to the fullnode (backup node) -->

## Pruning 

(a) If you have a separate fullnode with NO pruning connecting to bridge node, then you can use pruning settings for validator node as default and connect bridge node to your fullnode.

I am choosing pruning for validator node, and will use an archive node/fullnode connected to bridge node. This is preferable as it isolated validator node from bridge/full-node and also allows fullnode to act as a backup failsafe validator node if needed.

```
PRUNING="custom"
PRUNING_KEEP_RECENT="100"
PRUNING_INTERVAL="10"

sed -i -e "s/^pruning *=.*/pruning = \"$PRUNING\"/" $HOME/.celestia-app/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \
\"$PRUNING_KEEP_RECENT\"/" $HOME/.celestia-app/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \
\"$PRUNING_INTERVAL\"/" $HOME/.celestia-app/config/app.toml
```

```
indexer=null
```

OR

(b) If your bridge node is being connected to fullnode node, then use pruning=nothing for bridge node 

```
pruning:nothing
```

As mentioned for FIREWALL, need to allow INCOMING connections from Bridge Node IP to Full Node on 26657 port and need to change

## Download genesis file and replace in .celestia/config/genesis.json

Download pregensis from celestia github, rename it to genesis.json and move it to .celestia-app/config 
to overwrite the one that was created.

You can do this my cloning celestiaorg/network repository and then copying genesis file from networks/celestia/pre-genesis.json

```
git clone https://github.com/celestiaorg/networks.git
cp networks/celestia/pre-genesis.json .celestia-app/config/genesis.json
```


## Generate gentx

```
STAKING_AMOUNT=8000000utia
celestia-appd gentx $KEY_NAME $STAKING_AMOUNT --chain-id $CHAIN_ID \
    --pubkey=$(celestia-appd tendermint show-validator) \
    --moniker=$MONIKER \
    --commission-rate=0.05 \
    --commission-max-rate=0.12 \
    --commission-max-change-rate=0.02
```


## Things you have to backup

- 24 word mnemonic of your generated wallet
- contents of $HOME/.celestia-app/config/*


## Submit PR with Gentx

1. Copy the contents of ${HOME}/.celestia-app/config/gentx/gentx-XXXXXXXX.json.
2. use jq to make json pretty and copy <VALIDATORN_NAME>.json using 
```
jq . ${HOME}/.celestia-app/config/gentx/gentx-XXXXXXXX.json. > ${HOME}/<<VALIDATORN_NAME>.json>
```
2. Fork https://github.com/celestiaorg/networks
3. scp/cp file to this forked repo under celestiaorg/networks/celestia/gentx
4. Create a Pull Request to the main branch of the repository