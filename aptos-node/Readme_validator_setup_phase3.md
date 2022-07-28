### Aptos Incentivized Testnet-2 (AIT-2) 

## Hardware requirements
For running an Aptos node we recommend the following hardware resources:

CPU: 4 cores (Intel Xeon Skylake or newer).
Memory: 8GiB RAM.
Storage ~ 300GB

## Networking configuration requirements

For the Validator:

Open the TCP port 6180, for the Validators to talk to each other.
Open the TCP port 9101, for getting the Validator metrics to validate the health stats (only needed during registration stage).


## Installation using Aptos core source code

Using Aptos-core source code

# 1 Clone the Aptos repo.

```
git clone https://github.com/aptos-labs/aptos-core.git
```

cd into aptos-core directory.

```
cd aptos-core
```

# 2 Run the scripts/dev_setup.sh Bash script as shown below. This will prepare your developer environment.

```
./scripts/dev_setup.sh
```

DON't run cargo build here as you will do it later in a different branch and workspace.

Update your current shell environment.

```
source ~/.cargo/env
```

With your development environment ready, now you can start to setup your Validator node.

# 3 Checkout the testnet branch  

```
git checkout --track origin/testnet
```

# 4 Create a directory for your Aptos node composition.

```
export WORKSPACE=aptos_testnet
mkdir ~/$WORKSPACE
```

# 5 Generate key pairs (node owner key, consensus key and networking key) in your working directory.

Run the following command now to build the aptos repos and generate keys. Note this takes a while especially at the end so be patient.

```
cargo run --release -p aptos -- genesis generate-keys --output-dir ~/$WORKSPACE
```
This will create three files: private-keys.yaml, validator-identity.yaml, validator-full-node-identity.yaml for you. IMPORTANT: Backup your key files somewhere safe. These key files are important for you to establish ownership of your node, and you will use this information to claim your rewards later if eligible. Never share those keys with anyone else.

# 6 Configure validator information

You need to setup a static IP / DNS address which can be used by the node, and make sure the network / firewalls are properly configured to accept external connections. This is all the info you need to register on our community website later.

```
cargo run --release -p aptos -- genesis set-validator-configuration \
    --keys-dir ~/$WORKSPACE --local-repository-dir ~/$WORKSPACE \
    --username aptosbot \
    --validator-host <Validator Node IP / DNS address>:<Port> \
```

For example, with IP:

```
cargo run --release -p aptos -- genesis set-validator-configuration \
    --keys-dir ~/$WORKSPACE --local-repository-dir ~/$WORKSPACE \
    --username spidey \
    --validator-host 209.145.57.136:6180
```
This will create a YAML file in your working directory with your username, e.g., aptosbot.yaml. It looks like the below:

```
---
account_address: 7410973313fd0b5c69560fd8cd9c4aaeef873f869d292d1bb94b1872e737d64f
consensus_public_key: "0x4e6323a4692866d54316f3b08493f161746fda4daaacb6f0a04ec36b6160fdce"
account_public_key: "0x83f090aee4525052f3b504805c2a0b1d37553d611129289ede2fc9ca5f6aed3c"
validator_network_public_key: "0xa06381a17b090b8db5ffef97c6e861baad94a1b0e3210e6309de84c15337811d"
validator_host:
  host: 35.232.235.205
  port: 6180
full_node_network_public_key: "0xd66c403cae9f2939ade811e2f582ce8ad24122f0d961aa76be032ada68124f19"
full_node_host:
  host: 35.232.235.206
  port: 6182
stake_amount: 1
```

# 7 Create layout YAML file
This file defines the node in the validatorSet, for test mode, we can create a genesis blob containing only one node.

```
vi ~/$WORKSPACE/layout.yaml
```

Add the public key for root account, node username, and chain_id in the layout.yaml file, for example:

```
---
root_key: "F22409A93D1CD12D2FC92B5F8EB84CDCD24C348E32B3E7A720F3D2E288E63394"
users:
  - "<username you specified from previous step>"
chain_id: 40
min_stake: 0
max_stake: 100000
min_lockup_duration_secs: 0
max_lockup_duration_secs: 2592000
epoch_duration_secs: 86400
initial_lockup_timestamp: 1656615600
min_price_per_gas_unit: 1
allow_new_validators: true
```
Please make sure you use the same root public key as shown in the example and same chain ID, those config will be used during registration to verify your node.

# 8 Build AptosFramework Move bytecode and copy into the framework folder.

```
cargo run --release --package framework -- --package aptos-framework --output current
```
```
mkdir ~/$WORKSPACE/framework
```
```
mv aptos-framework/releases/artifacts/current/build/**/bytecode_modules/*.mv ~/$WORKSPACE/framework/
```
```
mv aptos-framework/releases/artifacts/current/build/**/bytecode_modules/dependencies/**/*.mv ~/$WORKSPACE/framework/

```

Alternatively, you can download the Aptos Framework from the release page: https://github.com/aptos-labs/aptos-core/releases/tag/aptos-framework-v0.2.0

```
wget https://github.com/aptos-labs/aptos-core/releases/download/aptos-framework-v0.2.0/framework.zip
unzip framework.zip
```

You will now have a folder called framework, which contains Move bytecode with the format .mv.

# 9 Compile genesis blob and waypoint.

```
cargo run --release -p aptos -- genesis generate-genesis --local-repository-dir ~/$WORKSPACE --output-dir ~/$WORKSPACE
```

This will create two files, genesis.blob and waypoint.txt, in your working directory.

# 10 Copy the validator.yaml, fullnode.yaml files into this directory.

```
mkdir ~/$WORKSPACE/config
cp docker/compose/aptos-node/validator.yaml ~/$WORKSPACE/validator.yaml
cp docker/compose/aptos-node/fullnode.yaml ~/$WORKSPACE/fullnode.yaml
```
Modify the config file (validator.yml) to update the key path, genesis file path, waypoint path from your $WORKSPACE folder.

# 11 To recap, in your working directory (~/$WORKSPACE), you should have a list of files:

- validator.yaml validator config file
- fullnode.yaml fullnode config file
- private-keys.yaml Private keys for owner account, consensus, networking
- validator-identity.yaml Private keys for setting validator identity
- validator-full-node-identity.yaml Private keys for setting validator full node identity
- <username>.yaml Node info for both validator / fullnode
- layout.yaml layout file to define root key, validator user, and chain ID
- framework folder which contains all the move bytecode for AptosFramework.
- waypoint.txt waypoint for genesis transaction
- genesis.blob genesis binary contains all the info about framework, validatorSet and more.

# 12 Start your local Validator by running the below command:

```
cargo run -p aptos-node --release -- -f ~/$WORKSPACE/validator.yaml
```

Now you have completed setting up your node in test mode. You can continue to our Aptos community platform website for registration.


# Useful commands

```
curl 209.145.57.136:8080

```
This should give something like this

{"chain_id":40,"epoch":2,"ledger_version":"30781","ledger_timestamp":"1656652474976312","node_role":"validator"}





