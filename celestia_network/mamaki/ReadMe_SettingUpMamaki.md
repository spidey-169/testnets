
### Setup The Dependencies

First, make sure to update and upgrade the OS:

```
sudo apt update && sudo apt upgrade -y
```

These are essential packages that are necessary to execute many tasks like downloading files, compiling and monitoring the node:

```
sudo apt install curl tar wget clang pkg-config libssl-dev jq build-essential \
git make ncdu -y

```

Install Golang

```
ver="1.18.2"
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

### Install Celestia App
The steps below will create a binary file named celestia-appd inside $HOME/go/bin folder which will be used later to run the node.

```
cd $HOME
rm -rf celestia-app
git clone https://github.com/celestiaorg/celestia-app.git
cd celestia-app/
APP_VERSION=$(curl -s \
  https://api.github.com/repos/celestiaorg/celestia-app/releases/latest \
  | jq -r ".tag_name")
git checkout tags/$APP_VERSION -b $APP_VERSION
make install
```

To check if the binary was successfully compiled you can run the binary using the --help flag:

```
celestia-appd --help

```

### Setup P2P Network

Now we will setup the P2P Networks by cloning the networks repository:

```
cd $HOME
rm -rf networks
git clone https://github.com/celestiaorg/networks.git
```

To initialize the network pick a "node-name" that describes your node. The --chain-id parameter we are using here is mamaki. Keep in mind that this might change if a new testnet is deployed. Please replace “node-name” by your name for example:

```
celestia-appd init "spidey" --chain-id mamaki
```

Copy the genesis.json file. For mamaki we are using:

```
cp $HOME/networks/mamaki/genesis.json $HOME/.celestia-app/config

```

Set seeds and peers:

```
BOOTSTRAP_PEERS=$(curl -sL https://raw.githubusercontent.com/celestiaorg/networks/master/mamaki/bootstrap-peers.txt | tr -d '\n')
echo $BOOTSTRAP_PEERS
sed -i.bak -e "s/^bootstrap-peers *=.*/bootstrap-peers = \"$BOOTSTRAP_PEERS\"/" $HOME/.celestia-app/config/config.toml

```

### Some more edits to config.toml file

In Config.toml file at .celestia-app/config/config.toml
Make sure to add you VPS ip address in external-address

```
external-address="<your_vps_ip>:26656"
```

make these changes as well to you config,toml file

```
use-legacy = true
timeout-commit = "25s"

max-connections = 250
max-num-inbound-peers = 180
max-num-outbound-peers = 70
You can set these 3 even higher if you want, it would be appreciated!

And also please double-check that these settings have the following values. If not, please change them:
timeout-propose = "3s"
skip-timeout-commit = false

```

Start by copying the entire command below:

```
e4429e99609c8c009969b0eb73c973bff33712f9@141.94.73.39:43656,09263a4168de6a2aaf7fef86669ddfe4e2d004f6@142.132.209.229:26656,13d8abce0ff9565ed223c5e4b9906160816ee8fa@94.62.146.145:36656,72b34325513863152269e781d9866d1ec4d6a93a@65.108.194.40:26676,322542cec82814d8903de2259b1d4d97026bcb75@51.178.133.224:26666,5273f0deefa5f9c2d0a3bbf70840bb44c65d835c@80.190.129.50:49656,7145da826bbf64f06aa4ad296b850fd697a211cc@176.57.189.212:26656,5a4c337189eed845f3ece17f88da0d94c7eb2f9c@209.126.84.147:26656,ec072065bd4c6126a5833c97c8eb2d4382db85be@88.99.249.251:26656,cd1524191300d6354d6a322ab0bca1d7c8ddfd01@95.216.223.149:26656,2fd76fae32f587eceb266dce19053b20fce4e846@207.154.220.138:26656,1d6a3c3d9ffc828b926f95592e15b1b59b5d8175@135.181.56.56:26656,fe2025284ad9517ee6e8b027024cf4ae17e320c9@198.244.164.11:26656,fcff172744c51684aaefc6fd3433eae275a2f31b@159.203.18.242:26656,f7b68a491bae4b10dbab09bb3a875781a01274a5@65.108.199.79:20356,6c076056fc80a813b26e24ba8d28fa374cd72777@149.102.153.197:26656,180378bab87c9cecea544eb406fcd8fcd2cbc21b@168.119.122.78:26656,88fa96d09a595a1208968727819367bd2fe8eabe@164.70.120.56:26656,84133cfde6e5fcaf5915436d56b3eef1d1996d17@45.132.245.56:26656,42b331adaa9ece4c455b92f0d26e3382e46d43f0@161.97.180.20:36656,c8c0456a5174ab082591a9466a6e0cb15c915a65@194.233.85.193:26656,6a62bf1f489a5231ddc320a2607ab2595558db75@154.12.240.49:26656,d0b19e4d133441fd41b4d74ac8de2138313ad49e@195.201.41.137:26656,bf199295d4c142ebf114232613d4796e6d81a8d0@159.69.110.238:26656,a46bbdb81e66c950e3cdbe5ee748a2d6bdb185dd@161.97.168.77:26656,831cd61b04ac95155f101723b851af53460d4d65@65.108.217.169:26656,550ab50ad0df01408928a3479e643286a47b4fc9@46.4.213.197:26656,43e9da043318a4ea0141259c17fcb06ecff816af@141.94.73.39:43656,45d0154bea2e0bbffec343894072f5feab19d242@65.108.71.92:43656,2e4084408b641a90c299a499c32874f0ab0f2956@65.108.44.149:22656,de6ba05f3ed583a12c396c182e5126ed65a32514@154.53.44.239:26656,d6fb487ff10d9878449beaa89007da15ec43057f@194.163.137.209:26656
```

Add it to persistent-peers in config.toml file

Enable firewall and allow ports

```
sudo ufw enable
sudo ufw allow ssh
sudo ufw allow 26656
sudo ufw allow 26657
sudo ufw allow 26658
sudo ufw allow 26660

```

Check status using
```
sudo ufw status
```

### Configure Pruning and Validator Mode

For lower disk space usage set up pruning using the configurations below:

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

Configure validator mode

```
sed -i.bak -e "s/^mode *=.*/mode = \"validator\"/" $HOME/.celestia-app/config/config.toml

```

### Reset Network
This will delete all data folders so we can start fresh:

```
celestia-appd tendermint unsafe-reset-all --home $HOME/.celestia-app

```

### QuickSync with Snapshot for Mamaki testnet (Optional but RECOMMENDED to reduce storage used)
Syncing from Genesis can take a long time, depending on your hardware. Using this method you can synchronize your Celestia node very quickly by downloading a recent snapshot of the blockchain

Run the following command to quick-sync from a snapshot for mamaki:

```
cd $HOME
rm -rf ~/.celestia-app/data
mkdir -p ~/.celestia-app/data
SNAP_NAME=$(curl -s https://snaps.qubelabs.io/celestia/ | \
    egrep -o ">mamaki.*tar" | tr -d ">")
wget -O - https://snaps.qubelabs.io/celestia/${SNAP_NAME} | tar xf - \
    -C ~/.celestia-app/data/

```

### Start the Celestia-App with SystemD

Create Celestia-App systemd file:

```
sudo tee <<EOF >/dev/null /etc/systemd/system/celestia-appd.service
[Unit]
Description=celestia-appd Cosmos daemon
After=network-online.target
[Service]
User=$USER
ExecStart=$HOME/go/bin/celestia-appd start
Restart=on-failure
RestartSec=3
LimitNOFILE=4096
[Install]
WantedBy=multi-user.target
EOF
```
If the file was created successfully you will be able to see its content:

```
cat /etc/systemd/system/celestia-appd.service
```

Enable and start celestia-appd daemon:

```
systemctl enable celestia-appd
systemctl start celestia-appd
```

Check if daemon has been started correctly:

```
systemctl status celestia-appd
```

Check daemon logs in real time:

```
journalctl -u celestia-appd.service -f

```

To check if your node is in sync before going forward: (NOTE: NODE should be INSYNC before next step)

```
curl -s localhost:26657/status | jq .result | jq .sync_info

```

If you are facing issues, check to see if you have made changes to config.toml file as mentioned before as well as have all relevant ports open


### Create a Wallet

First, create an application CLI configuration file:

```
celestia-appd config keyring-backend test
```

Pick whatever wallet name you want. For our example we used "validator" as the wallet name:

```
celestia-appd keys add celestia-validator

```
Save the mnemonic output as this is the only way to recover your validator wallet in case you lose it!

To check all your wallets you can run:

```
celestia-appd keys list
```

To check if tokens have arrived successfully to the destination wallet run the command below replacing the public address with your own:

```
celestia-appd q bank balances celestia1xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```

### Delegate Stake to a Validator

Create an environment variable for the address:

```
VALIDATOR_WALLET=<validator-address>
```

Please replace <validator-adress> by your public adress (an example below):

```
VALIDATOR_WALLET=celestia1qjshyuh77s7sz0l5kq4ft22pm0686qf3l0yvwz
```

```
celestia-appd keys show $VALIDATOR_WALLET --bech val -a
```

This gives you celesvaloper address, in my case this is "celestiavaloper1qjshyuh77s7sz0l5kq4ft22pm0686qf36sx4cy"
For me 

```
Validator address: celestia1qjshyuh77s7sz0l5kq4ft22pm0686qf3l0yvwz
celesvaloper address: celestiavaloper1qjshyuh77s7sz0l5kq4ft22pm0686qf36sx4cy
```

### Connect/Create Validator

```
MONIKER="spidey"
VALIDATOR_WALLET="validator"

celestia-appd tx staking create-validator \
    --amount=1000000utia \
    --pubkey=$(celestia-appd tendermint show-validator) \
    --moniker=$MONIKER \
    --chain-id=mamaki \
    --commission-rate=0.1 \
    --commission-max-rate=0.2 \
    --commission-max-change-rate=0.01 \
    --min-self-delegation=1000000 \
    --from=$VALIDATOR_WALLET \
    --keyring-backend=test
```

Please replace MONIKER by your validator name and “wallet” by your wallet name "celestia1qjshyuh77s7sz0l5kq4ft22pm0686qf3l0yvwz"  for example

```
MONIKER="spidey"
VALIDATOR_WALLET=celestia1qjshyuh77s7sz0l5kq4ft22pm0686qf3l0yvwz

celestia-appd tx staking create-validator \
    --amount=1000000utia \
    --pubkey=$(celestia-appd tendermint show-validator) \
    --moniker=$MONIKER \
    --chain-id=mamaki \
    --commission-rate=0.1 \
    --commission-max-rate=0.2 \
    --commission-max-change-rate=0.01 \
    --min-self-delegation=1000000 \
    --from=$VALIDATOR_WALLET \
    --keyring-backend=test
```

### Delegate to the validator

```
celestia-appd tx staking delegate \
celestiavaloper1qjshyuh77s7sz0l5kq4ft22pm0686qf36sx4cy 10000000utia \
--from=celestia1qjshyuh77s7sz0l5kq4ft22pm0686qf3l0yvwz --chain-id=mamaki
```

Need minimum 10 TIA to become active

### Backup validator keys

```
tar -czvf validator_key.tar.gz .celestia-appd/config/*_key.json 
gpg -o validator_key.tar.gz.gpg -ca validator_key.tar.gz
rm validator_key.tar.gz
```

### Unjail command

```
celestia-appd tx slashing unjail --from celestia1qjshyuh77s7sz0l5kq4ft22pm0686qf3l0yvwz --chain-id mamaki

```

### Check Logs of node

```
journalctl -u celestia-appd.service -f --no-hostname -o cat
```