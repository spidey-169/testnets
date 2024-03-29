
# Miscellanous command to edit validator details

## Command to get available options for editing validator

```
celestia-appd tx staking edit-validator --help
```

```
Usage:
  celestia-appd tx staking edit-validator [flags]

Flags:
  -a, --account-number uint          The account number of the signing account (offline mode only)
      --aux                          Generate aux signer data instead of sending a tx
  -b, --broadcast-mode string        Transaction broadcasting mode (sync|async|block) (default "sync")
      --commission-rate string       The new commission rate percentage
      --details string               The validator's (optional) details (default "[do-not-modify]")
      --dry-run                      ignore the --gas flag and perform a simulation of a transaction, but don't broadcast it (when enabled, the local Keybase is not accessible)
      --evm-address string           The 0x EVM address of the orchestrator
      --fee-granter string           Fee granter grants fees for the transaction
      --fee-payer string             Fee payer pays fees for the transaction instead of deducting from the signer
      --fees string                  Fees to pay along with transaction; eg: 10uatom
      --from string                  Name or address of private key with which to sign
      --gas string                   gas limit to set per-transaction; set to "auto" to calculate sufficient gas automatically. Note: "auto" option doesn't always report accurate results. Set a valid coin value to adjust the result. Can be used instead of "fees". (default 210000)
      --gas-adjustment float         adjustment factor to be multiplied against the estimate returned by the tx simulation; if the gas limit is set manually this flag is ignored  (default 1)
      --gas-prices string            Gas prices in decimal format to determine the transaction fee (e.g. 0.1uatom)
      --generate-only                Build an unsigned transaction and write it to STDOUT (when enabled, the local Keybase only accessed when providing a key name)
  -h, --help                         help for edit-validator
      --identity string              The (optional) identity signature (ex. UPort or Keybase) (default "[do-not-modify]")
      --keyring-backend string       Select keyring's backend (os|file|kwallet|pass|test|memory) (default "test")
      --keyring-dir string           The client Keyring directory; if omitted, the default 'home' directory will be used
      --ledger                       Use a connected Ledger device
      --min-self-delegation string   The minimum self delegation required on the validator
      --new-moniker string           The validator's name (default "[do-not-modify]")
      --node string                  <host>:<port> to tendermint rpc interface for this chain (default "tcp://localhost:26657")
      --note string                  Note to add a description to the transaction (previously --memo)
      --offline                      Offline mode (does not allow any online functionality)
  -o, --output string                Output format (text|json) (default "json")
      --security-contact string      The validator's (optional) security contact email (default "[do-not-modify]")
  -s, --sequence uint                The sequence number of the signing account (offline mode only)
      --sign-mode string             Choose sign mode (direct|amino-json|direct-aux), this is an advanced feature
      --timeout-height uint          Set a block timeout height to prevent the tx from being committed past a certain height
      --tip string                   Tip is the amount that is going to be transferred to the fee payer on the target chain. This flag is only valid when used with --aux, and is ignored if the target chain didn't enable the TipDecorator
      --website string               The validator's (optional) website (default "[do-not-modify]")
  -y, --yes                          Skip tx broadcasting prompt confirmation

Global Flags:
      --chain-id string     The network chain ID
      --home string         directory for config and data (default "/home/celestia/.celestia-app")
      --log_format string   The logging format (json|plain) (default "plain")

```
# Editing an existing validator

## Adding identity to existing validator

```
celestia-appd tx staking edit-validator --identity=$PGP_KEY_FROM_KEYBASE --chain-id blockspacerace-0 --from $VALIDATOR_WALLET --fees=1000utia
```

## Adding description to existing validator

```
celestia-appd tx staking edit-validator --details="Full stack developer, expert node operator and community supporter at your service" --chain-id blockspacerace-0 --from $VALIDATOR_WALLET --fees=1000utia
```

## Adding website to existing validator

```
celestia-appd tx staking edit-validator --website <website_url> --chain-id blockspacerace-0 --from $VALIDATOR_WALLET --fees=1000utia
```

## Claiming a rewards for a validator

Rewards can be claimed using the following command. 

```
celestia-appd tx distribution withdraw-rewards celestiavaloper1q4qtpgw9m6l4ezj6v0pc7l79eq7fpd83a642yx --commission --from=celestia1q4qtpgw9m6l4ezj6v0pc7l79eq7fpd83c9hnjq --chain-id blockspacerace-0  --fees=1000utia --gas auto -y
```

Here make sure to give the --fees=1000utia flag (in addition to --gas auto -y) to ensure that txn doesn't get reverted. If you transaction is using lesser fees than required you will get the following error, where the raw log clearly mentions that fees are not sufficient:

```
gas estimate: 133862
code: 13
codespace: sdk
data: ""
events: []
gas_used: "0"
gas_wanted: "0"
height: "0"
info: ""
logs: []
raw_log: 'insufficient fees; got:  required: 134utia: insufficient fee'
timestamp: ""
tx: null
txhash: D65212599F18BED8877766417EB4EF5C12FC05D40C316EEFC6F8F036B8CFE448
```

For a correct submission the output will look like
```
gas estimate: 150956
code: 0
codespace: ""
data: ""
events: []
gas_used: "0"
gas_wanted: "0"
height: "0"
info: ""
logs: []
raw_log: '[]'
timestamp: ""
tx: null
txhash: 3300646B582FC0169F907F75A6A3E8683A259A9D5EE66F8FCB24AA2C2CADAF44
```

You can always check the transaction hash on the explorer to see if the transaction was successful
 
 # Delegating to a validator

Delegte you tokens to a validator using : 

```
celestia-appd tx staking delegate celestiavaloper1q4qtpgw9m6l4ezj6v0pc7l79eq7fpd83a642yx 28000000000utia\
    --from celestia1q4qtpgw9m6l4ezj6v0pc7l79eq7fpd83c9hnjq --chain-id blockspacerace-0  --fees=1000utia --gas auto -y
```

This will stake 28000 TIA tokens to validator with celestiavaloper address: celestiavaloper1q4qtpgw9m6l4ezj6v0pc7l79eq7fpd83a642yx from wallet address: celestia1q4qtpgw9m6l4ezj6v0pc7l79eq7fpd83c9hnjq

Note again, we have added additional flags (--fees=1000utia --gas auto -y) to make sure txn has the sufficient fees to get mined.

Once again a successful txn will look like:

```
as estimate: 176338
code: 0
codespace: ""
data: ""
events: []
gas_used: "0"
gas_wanted: "0"
height: "0"
info: ""
logs: []
raw_log: '[]'
timestamp: ""
tx: null
txhash: 9768103B56E40A06F504E79666DA7C4AC79834B78383B1EC79CB37F9A58A0192
```

You can always check the transaction hash on the explorer to see if the transaction was successful