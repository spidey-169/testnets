#  README GENTX Celestia Network

## Create a new user account on the dedicated server

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
```


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

## Init node

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

### Option 1 - generate new wallet

```
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
```

### Option 2 - recover existing wallet

USE THIS WALLET if you already submitted a wallet information during blockspacerace

```
KEY_NAME=validator-mainnet
celestia-appd keys add wallet --recover
```

<!-- ## Add genesis account -->

<!-- NO NEED for this step, since the genesis.json file already contains the balance for the address -->

<!-- ```
CELES_AMOUNT="8000000utia"
celestia-appd add-genesis-account $KEY_NAME $CELES_AMOUNT
``` -->

## Download genesis file

Download pregensis from celestia github, rename it to genesis.json and move it to .celestia-app/config 
to overwrite the one that was created

## Generate gentx

```
STAKING_AMOUNT=8000000utia
celestia-appd gentx $KEY_NAME $STAKING_AMOUNT --chain-id $CHAIN_ID \
    --pubkey=$(celestia-appd tendermint show-validator) \
    --moniker=$MONIKER \
    --commission-rate=0.05 \
    --commission-max-rate=0.12 \
    --commission-max-change-rate=0.01 
```


## Things you have to backup

- 24 word mnemonic of your generated wallet
- contents of $HOME/.celestia-app/config/*


## Submit PR with Gentx

1. Copy the contents of ${HOME}/.celestia-app/config/gentx/gentx-XXXXXXXX.json.
2. Fork https://github.com/celestiaorg/networks
3. Create a file <VALIDATOR_NAME>.json under the networks/celestia/gentx folder in the forked repo, paste the copied text into the file.
4. Create a Pull Request to the main branch of the repository