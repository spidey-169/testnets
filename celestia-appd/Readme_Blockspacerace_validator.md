# README Validator node Celestia (init during gentx)

## Copy genesis file from networks

```
cd $HOME
rm -rf networks
git clone https://github.com/celestiaorg/networks/
```

copy genesis file into .config

```
cp $HOME/networks/blockspacerace/genesis.json $HOME/.celestia-app/config
```

# Configure config.toml and app.toml

## Add seeds and peers to config.toml

Set seeds and peers from https://github.com/celestiaorg/networks/tree/master/blockspacerace into config.toml

seeds="0293f2cf7184da95bc6ea6ff31c7e97578b9c7ff@65.109.106.95:26656,8f14ec71e1d712c912c27485a169c2519628cfb6@celest-test-seed.theamsolutions.info:22256"
peers="be935b5942fd13c739983a53416006c83837a4d2@178.170.47.171:26656,cea09c9ac235a143d4b6a9d1ba5df6902b2bc2bd@95.214.54.28:20656,5c9cfba00df2aaa9f9fe26952e4bf912e3f1e8ee@195.3.221.5:26656"

## Some more edits to config.toml file

In Config.toml file at .celestia-app/config/config.toml
Make sure to add you VPS ip address in external-address

```
external-address="<your_vps_ip>:26656"
```

Enable firewall and allow ports

```
sudo ufw enable
sudo ufw allow ssh
sudo ufw allow 26656
sudo ufw allow 26657
```

Check status using
```
sudo ufw status
```

## Configure Pruning and Validator Mode

Disable pruning for now and set it to "nothing" in app.toml file (Required for blockspacerace-0 during genesis)

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

## Configure validator mode

```
sed -i.bak -e "s/^mode *=.*/mode = \"validator\"/" $HOME/.celestia-app/config/config.toml

```

## Reset Network
If you are not using a fresh new server, then only do this.

This will delete all data folders so we can start fresh:

```
celestia-appd tendermint unsafe-reset-all --home $HOME/.celestia-app

```

## QuickSync with Snapshot for Mamaki testnet (Optional but RECOMMENDED to reduce storage used)
DON'T do this if you are genesis validator, since you will be signing blocks from block 0.

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

## Start the Celestia-App with SystemD (Validator Node)

This will start the validator as the validator node was already created during gentx generation

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

## Backup validator keys

tar -czvf validator_key.tar.gz .celestia-appd/config/*_key.json 
gpg -o validator_key.tar.gz.gpg -ca validator_key.tar.gz
rm validator_key.tar.gz


# Miscellanous Commands

## Delegate to the validator

```
celestia-appd tx staking delegate \
celestiavaloper1qjshyuh77s7sz0l5kq4ft22pm0686qf36sx4cy 10000000utia \
--from=celestia1qjshyuh77s7sz0l5kq4ft22pm0686qf3l0yvwz --chain-id=mocha
```

Need minimum 10 TIA to become active

## Unjail command

```
celestia-appd tx slashing unjail --from celestia1qjshyuh77s7sz0l5kq4ft22pm0686qf3l0yvwz --chain-id mamaki

```

## Check Logs of node

```
journalctl -u celestia-appd.service -f --no-hostname -o cat
```