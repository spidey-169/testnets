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

USE THIS WALLET since you already submitted a wallet information during blockspacerace and your wallet is already in genesis.json

```
KEY_NAME=validator-mainnet
celestia-appd keys add $KEY_NAME --recover
```

Next type BIP mnemonic of the key to recover it.

## Check list of commands for wallet

```
celestia-appd keys
```

```Available Commands:
  add         Add an encrypted private key (either newly generated or recovered), encrypt it, and save to <name> file
  delete      Delete the given keys
  export      Export private keys
  import      Import private keys into the local keybase
  list        List all keys
  migrate     Migrate keys from amino to proto serialization format
  mnemonic    Compute the bip39 mnemonic for some input entropy
  parse       Parse address from hex to bech32 and vice versa
  rename      Rename an existing key
  show        Retrieve key information by name or address

Flags:
  -h, --help                     help for keys
      --home string              The application home directory (default "/home/spidey/.celestia-app")
      --keyring-backend string   Select keyring's backend (os|file|test) (default "test")
      --keyring-dir string       The client Keyring directory; if omitted, the default 'home' directory will be used
      --output string            Output format (text|json) (default "text")

Global Flags:
      --log-to-file string   Write logs directly to a file. If empty, logs are written to stderr
      --log_format string    The logging format (json|plain) (default "plain")
      --log_level string     The logging level (trace|debug|info|warn|error|fatal|panic) (default "info")
      --trace                print out full stack trace on errors

Use "celestia-appd keys [command] --help" for more information about a command.
```

## Delete a local wallet copy (AFTER BACKING UP SEED safely)

```
celestia-appd keys delete <KEY_NAME>
```

### Rename an exisitng wallet 

```
celestia-appd keys rename <OLD_NAME> <NEW_NAME>
```

### List all wallets

```
celestia-appd keys list
```

