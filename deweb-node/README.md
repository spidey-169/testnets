# deweb-testnet
Decentralized Web Services
dewebd is a blockchain application built using Cosmos SDK v.0.45.0 and Tendermint v.0.34.15.

Hardware Requirements

8GB RAM
4vCPUs
200GB Disk space

Install deps

```
sudo apt-get install build-essential jq

```

Software Requirements

Install deps

```
sudo apt-get install build-essential jq

```

Compile instructions: install GoLang
Install Go 1.17.x The official instructions can be found here: https://golang.org/doc/install

First remove any existing old Go installation as root

```
sudo rm -rf /usr/local/go
```

Download the software:

```
curl https://dl.google.com/go/go1.17.6.linux-amd64.tar.gz | sudo tar -C/usr/local -zxvf

```
-
Update environment variables to include go (copy everything and paste)

```
cat <<'EOF' >>$HOME/.profile
export GOROOT=/usr/local/go
export GOPATH=$HOME/go
export GO111MODULE=on
export GOBIN=$HOME/go/bin
export PATH=$PATH:/usr/local/go/bin:$GOBIN
EOF
source $HOME/.profile
```

To verify that Go is installed:

```
go version
```
Should return go version go1.17.6 linux/amd64

Compile dewebd source code by yourself
Download source code and compile

```
git clone https://github.com/deweb-services/deweb.git
cd deweb
git checkout v0.2
make build   #it build the binary in build/ folder
```