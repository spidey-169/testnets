
# Validator Server Migration Step by Step Process:

Validator nodes can come across hardware issues and sometimes, its important to migrate your validator node to a full-syncd non-validator node. 

If not done correctly, your validator can get tombstoned, hence its absolutely vital to follow the below steps:

## Scenario

We have two nodes: validator Node A and fully-synced non-validator Node B. We want to move the validator role from Node A to Node B.

## BACKUP Validator keys

You need to backup validator keys (/config/priv_validator_key.json,/config/node_key.json) when you create your validator, you will need these along with (/date/priv_validator_state.json)

NOTE: You need to copy of priv_validator_state.json AFTER you switch off NODE A (existing validator node), as priv_validator_state.json is continuously changing and tracking the last signed block. 

## STEPS:

1. get node B synced up to chainhead and running. 
2. Make sure you backup priv_validator_key.json and node_key.json (you can do this anytime) on Node A
3. Stop Node A
4. Check to confirm you have stopped signing (explorers, pvtop etc) [ensure you are not signing blocks on multiple explorers and wait atleast 2-3 blocks before proceeding]
5. Backup priv_validator_state.json after STEP 4 (cat it in your terminal so double check that block is the block you see missing on explorer)
6. Remove the priv_validator_key.json from Node A (delete or move out of /config folder)
7. Run Node A again, now you can check its no longer signing as your val. it will create a new priv_validator_key.json
8. ``curl http://localhost:26657/status``  on Node A and make sure it says ``"voting_power":"0"}}}``
9. Stop Node B
10. Swap in your backed up files (node key, priv val key, state json) 
11. Start Node B
12. ```curl http://localhost:26657/status```  on Node B and you should see voting power > 0, signing on explorer etc.
13. Now you can nuke Node A and you're done 

These steps saving my validator node right after genesis. Feel free to follow these or contact me if you need any help in the future.

I would like to thank [Vince](https://github.com/kw1knode) for guiding me through these steps. 
