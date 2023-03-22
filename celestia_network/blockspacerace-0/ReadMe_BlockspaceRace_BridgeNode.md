# README Bridge Node Celestia

## Install celestia-node

Installing celestia-node for the blockspacerace testnet means installing a specific version to be compatible with the network.

### Install the celestia-node binary by running the following commands:

```
cd $HOME 
rm -rf celestia-node 
git clone https://github.com/celestiaorg/celestia-node.git 
cd celestia-node/ 
git checkout tags/v0.7.1 
make build 
make install 
make cel-key 
```

### Verify that the binary is working and check the version with the celestia version command:

```
celestia version 
```
Output should look like

```
Semantic version: v0.7.1 
Commit: 7226f02794bdf11a91116d0d4cd88399f05149ad 
Build Date: Thu Dec 15 10:19:22 PM UTC 2022 
System version: amd64/linux 
Golang version: go1.19.1 
```

### Initialize the bridge node

Please use your own celestia-app node as the endpoint for your bridge node, this can be done by specifying

--core.ip localhost:26657 (<ipaddress:-rpc-port>)
ipaddress can also be replaced by local_host if you are running validator and bridge node on the same node.

```
celestia bridge init --core.ip localhost:26657 --p2p.network blockspacerace
```

OR

```
celestia bridge init --core.ip localhost --core.rpc.port 26657 --p2p.network blockspacerace
```

From bridge config.toml

```
toml 
[Core]
  IP = "localhost"
  RPCPort = "26657"
  GRPCPort = "9090"
```

The rpc port 26657, can be found from your config.toml file under "RPC Server Configuration Options" or config.toml for Bridge node

```
toml 
[Core]
  IP = "localhost"
  RPCPort = "26657"
  GRPCPort = "9090"
```

This will create a few key and the output should look like

```
2023-03-14T21:32:56.819+0100    INFO    node    nodebuilder/init.go:26  Initializing Bridge Node Store over '/home/celestia/.celestia-bridge-blockspacerace-0'
2023-03-14T21:32:56.820+0100    INFO    node    nodebuilder/init.go:58  Saved config    {"path": "/home/celestia/.celestia-bridge-blockspacerace-0/config.toml"}
2023-03-14T21:32:56.820+0100    INFO    node    nodebuilder/init.go:60  Accessing keyring...
2023-03-14T21:32:56.822+0100    WARN    node    nodebuilder/init.go:132 Detected plaintext keyring backend. For elevated security properties, consider usingthe `file` keyring backend.
2023-03-14T21:32:56.822+0100    INFO    node    nodebuilder/init.go:147 NO KEY FOUND IN STORE, GENERATING NEW KEY...    {"path": "/home/celestia/.celestia-bridge-blockspacerace-0/keys"}
2023-03-14T21:32:56.837+0100    INFO    node    nodebuilder/init.go:153 NEW KEY GENERATED...
```

Save the mnemonic in a safe place offline, as you will need it recover the wallet

### Backup Bridge keys

Backup the bridge keys in the keys folder

```
tar -czvf bridge_node_key.tar.gz tar ~/.celestia-bridge-blockspacerace-0/keys/*
gpg -o bridge_node_key.tar.gz.gpg -ca bridge_node_key.tar.gz
rm bridge_node_key.tar.gz
```


### Recover Bridge keys

```
cel-key add bridge --recover \
        --p2p.network blockspacerace \
        --node.type bridge \
        --keyring-dir .celestia-bridge-blockspacerace-0/keys
```



### Run the bridge node

```
celestia bridge start --core.ip localhost:26657 --p2p.network blockspacerace --metrics.tls=false --metrics --metrics.endpoint otel.celestia.tools:4318
```

OR

```
celestia bridge start --core.ip localhost --core.rpc.port 26657 --p2p.network blockspacerace --metrics.tls=false --metrics --metrics.endpoint otel.celestia.tools:4318
```

Once you start the Bridge Node, a wallet key will be generated for you. You will need to fund that address with Testnet tokens to pay for PayForBlob transactions. You can find the address by running the following command:

```
./cel-key list --node.type bridge --keyring-backend test --p2p.network blockspacerace

```

You can get testnet tokens from faucet.

### Run Bridge node as Systemd service

Create Celestia Bridge systemd file:

```
sudo tee <<EOF >/dev/null /etc/systemd/system/celestia-bridge.service
[Unit]
Description=celestia-bridge Cosmos daemon
After=network-online.target

[Service]
User=$USER
ExecStart=/home/celestia/celestia-node/build/celestia bridge start --core.ip localhost:26657 --p2p.network blockspacerace --metrics.tls=false --metrics --metrics.endpoint otel.celestia.tools:4318
Restart=on-failure
RestartSec=3
LimitNOFILE=4096

[Install]
WantedBy=multi-user.target
EOF
```

If the file was created successfully you will be able to see its content:

```
cat /etc/systemd/system/celestia-bridge.service
```

Enable and start celestia-bridge daemon:

```
sudo systemctl enable celestia-bridge
sudo systemctl start celestia-bridge && sudo journalctl -u \
celestia-bridge.service -f
```

### NODE_ID of bridge node

This is an RPC call in order to get your node's peerId information.

To get that information, you will need to first generate an auth token:

```
NODE_TYPE=bridge
AUTH_TOKEN=$(celestia $NODE_TYPE auth admin --p2p.network blockspacerace)
```

The command generates an auth token that we save to an environment variable.

Request

Then you can get the peerId of your node with the following curl command:

```
curl -X POST \
     -H "Authorization: Bearer $AUTH_TOKEN" \
     -H 'Content-Type: application/json' \
     -d '{"jsonrpc":"2.0","id":0,"method":"p2p.Info","params":[]}' \
     http://localhost:26658
```

Response

```
{
  "jsonrpc": "2.0",
  "result": {
    "ID": "12D3KooWSHFDzY7Z7ChLC7VhZikAsjjYrXNDpvKcBKUow2oZ9fGj",
    "Addrs": [
      "/ip4/192.168.1.176/udp/2121/quic",
      "/ip4/127.0.0.1/udp/2121/quic",
      "/ip6/::1/udp/2121/quic",
      "/ip4/192.168.1.176/tcp/2121",
      "/ip6/::1/tcp/2121",
      "/ip4/81.87.20.64/udp/5619/quic"
    ]
  },
  "id": 0
}
```
The node ID is in the ID value from the response.


### Update your bridge node (when needed) with the latest tags

In this case we are updating to v/0.7.2 tag.

ALWAYS, MAKE SURE TO HAVE BACKED UP YOUR /keys folder beforehand


1. stop your bridge node
```
sudo systemctl stop celestia-bridge
```

2. Delete the old data
DON'T delete the old /keys as we need the keys to be the same

```
cd .celestia-bridge-blockspacerace-0
rm -rf blocks/ 
rm -rf data/ 
rm -rf index/ 
rm -rf transients/ 
```
3. upgrade to v0.7.2
```
git checkout main && git pull && git checkout  tags/v0.7.2 && make build && sudo make install
```

4. init your bridge node again 
NOTE, this will DETECT your old keys and use them. 

```
celestia bridge init --core.ip localhost:26657 --p2p.network blockspacerace
```

6. start your bridge node

```
sudo systemctl start celestia-bridge
```

7. Check logs and if its syncing correctly

```
sudo journalctl -u \
celestia-bridge.service -f
```























