## Manage Ports/Firewall

## MANAGE PORTS (IMPORTANT) (Config.toml file edits) 

Add your public IP, port information to the list of external address and also configure laddr ports

### 1. Listening address(laddr)/port (P2P) for p2p connection in config.toml, 

default=26656

Check/Modify default LISTENING port 26656 for p2p connection if setting validator on guest proxmox node, p2p address is where your guest is listening to (this can be defaut 26656 or user definded). 

``This means its listening( need to ALLOW IN packets) from ANY SOURCE to DESTINATION(on this node) port 26656``

### (a) (NON_PROXMOX nodes) Keep P2P LISTENING port to be DEFAULT (26656), Recommended for NON-Proxmox guest nodes or isolated nodes where 26656 is always free 

You can keep this address to be the default address 26656, if using a dedicated node and no conflict between ports (fresh cloud node without anything else running on it now or in future). This is good choice if you have a separate node hosted on a separate server and port 26656 will not be in conflict.

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

``NOTE: FIREWALL needs to ALLOW IN packets from SOURCE to DESTINATION (this node) port 26656)``


### (b)(PROXMOX GUEST Node) Recommended to EDIT to USER_DEFINED P2P LISTENING port from 26656 to another port say 26603, USEFUL when hosting fullnode/validator on Proxmox GUEST. (ANY SOURCE to DESTINATION 26603 on node)

``This means its listening(need to ALLOW IN packets) from ANY SOURCE to DESTINATION (this node) port 26603``

If you wish to install validator/fullnode as a guest node (proxmox guest), you can edit the default LISTENING p2p port for validator/fullnode from 26656 be 26603 (in case 26656 is taken). This is desirable say if you want multiple testnets of celestia, to be run as different guest nodes and all need access to 26656. This changes the default port for listening for p2p connection for validator from 26656 to 26603. This is important if you are using say a proxmox guest node for validator and using natting to map ports from guest to host node. 


``NOTE: You will also need to setup natting from Guest port 26603 to Host port 26603. If you have firewall, you need to open 26603 port in firewall for both GUEST and HOST node to allow it to listen in on this port``


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

``NOTE: FIREWALL needs to ALLOW IN packets from SOURCE to DESTINATION (this node) port 26603``

### 2.  EXTERNAL address (P2P) 

Add HOST IP/Public IP to the list of external address in config.toml, this is where the HOST node is listening to.

Here I will add my PROXMOX_HOST_IP/PUBLIC_IP  and respective port to external_address under P2P configuration

### (a) NON_PROXMOX nodes hosting validator/fullnode

use PUBLIC IP (one from -ifconfig) and port same as p2p port (DEFAULT port (26656) as this is recommended option and not changed above)

``NOTE: This means its listening (need to ALLOW IN packets) from ANY SOURCE to DESTINATION(this host node) P2P port 26656``


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
``NOTE: Firewall enabled on HOST node to ALLOW IN connections from SOURCE to DESTINATION (this HOST_NODE) port 26656``

### (b) PROXMOX_Guest node hosting validator/fullnode

In case of hosting on a guest proxmox node use PROXMOX_HOST_IP (ip corresponding to host of proxmox server which is also the public IP address) and port same as USER_DEFINED LISTENING p2p port chosen (26603 chosen before)

``NOTE: This means its listening ( need to ALLOW IN packets) from ANY SOURCE to DESTINATION (this PROXMOX_HOST node) P2P port 26603 ``


```
external_address=<YOUR_HOST_IP>:26603 (user_defined_p2p_port)
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

``NOTE: Firewall enabled on HOST node to ALLOW IN connections from SOURCE to DESTINATION (this HOST_NODE) port 26603``

### 3.  LISTENING address/port (laddr) for RPC. 

default=26657

If you are going to run a bridge node and need to connect it to validator/fullnode, you also need to allow port 26657 (default rpc port) from your validator/fullnode node to be able to accessed by your bridge node.

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

``REMEMBER, if FIREWALL is ENABLED, you need to ALLOW-IN <BRIDGE NODE IP> to be able to access FullNode/Validator NODE port 26657 (See Firewall rules below)``

#### NOTE you can also edit the default listening address for RPC as well, follow same process of editing port as p2p and make sure to keep it open for Bridge Nodes to be connected to RPC

### 4.  LISTENING address/port (laddr) for gRPC. 

default=9090

If you are going to run a bridge node and need to connect it to validator/fullnode, you also need to allow port 9090 (default grpc port) from your validator/fullnode node to be able to accessed by your bridge node.

You can do this by setting address in gRPC SERVER CONNECTIONs and allowing firewall for this port to allowing incoming connection.

```
address = 0:0:0:0:9090

```

This will change the setting as follows:
```
###############################################################################
###                           gRPC Configuration                            ###
###############################################################################

[grpc]

# Enable defines if the gRPC server should be enabled.
enable = true

# Address defines the gRPC server address to bind to.
address = "0.0.0.0:9090"
```

``REMEMBER, if FIREWALL is ENABLED, you need to ALLOW-IN <BRIDGE NODE IP> to be able to access FullNode/Validator NODE port 9090 (See Firewall rules below)``

#### NOTE you can also edit the default listening address for RPC as well, follow same process of editing port as p2p and make sure to keep it open for Bridge Nodes to be connected to RPC


## FIREWALL: Setting up firewall when hosting validator on proxmox guest node/ vs separate server node (one can use ufw too)

Proxmox firewall configurations only allow to proxmox instance
### 1.  OPEN SSH port 22 on guest node 

``Settings for Proxmox firewall (via GUI interface)``:

Here: DESTINATION port (D.Port) is 22, interface: net0, Protocol: tcp, ACTION: accept, TYPE:in

### OR

``Setting for ufw``:
```
sudo ufw allow ssh
```

### (2a) (NON-PROXMOX NODE) OPEN DEFAULT listening port for p2p connection, 26656 
``Settings for ufw``:
```
sudo ufw allow 26656
```

### (2b) (PROXMOX GUEST NODE only), OPEN USER_SPECIFIED listening port for p2p connection (set above), 26603 on guest node (when P2P default port has been changed)

``Settings for Proxmox firewall (via GUI interface)``:

Here DESTINATION port (D.Port) is 26603, interface: net0, Protocol: tcp, ACTION: accept, TYPE:in

 ### OR 

``Settings for ufw``:
```
sudo ufw allow 26603
```

###  3. OPEN listening port p2p connection, 26603 on host node (if firewall enabled on host)

###  4. (IMPORTANT IF BRIDGE NODE IS CONNECTING TO THIS VALIDATOR/FULLNODE) OPEN RPC listening port 26657 ONLY to bridge node IP (SOURCE)

``Settings for Proxmox firewall (via GUI interface)``:
Here DESTINATION port (D.Port) is 26657, SOURCE: <BRIDGE_NODE_IP> interface: net0, Protocol: tcp, ACTION: accept, TYPE:in
 
 ### OR

``Settings for ufw``:
sudo ufw allow from <BRIDGE_NODE_IP> proto tcp to any port 26657


You can also connect bridge node to the fullnode (backup node)

###  5. (IMPORTANT IF BRIDGE NODE IS CONNECTING TO THIS VALIDATOR/FULLNODE) OPEN gRPC listening port 9090 ONLY to bridge node IP (SOURCE)

``Settings for Proxmox firewall (via GUI interface)``:
Here DESTINATION port (D.Port) is 9090, SOURCE: <BRIDGE_NODE_IP> interface: net0, Protocol: tcp, ACTION: accept, TYPE:in
 
 ### OR

``Settings for ufw``:
sudo ufw allow from <BRIDGE_NODE_IP> proto tcp to any port 9090


You can also connect bridge node to the fullnode (backup node)