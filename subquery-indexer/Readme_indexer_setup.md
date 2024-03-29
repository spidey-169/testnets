# Subquery Testnet Phase 3

## Step 1- Install Docker and Docker-Compose
Launch VM

## Step 2- Install Docker and Docker-Compose

### Install Docker (taken from digital ocean docs)

Set some permissions and install some dependencies

```
sudo apt update
```

```
sudo apt install apt-transport-https ca-certificates curl software-properties-common
```

```
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
```

```
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
```

```
sudo apt update
```
```
apt-cache policy docker-ce
```
```
sudo systemctl status docker

```

Finally, install Docker:

```
sudo apt install docker-ce
```

Check its running

```
sudo systemctl status docker
```

Enable docker using systemctl and start docker again to configure auto restart

```
sudo systemctl enable docker
sudo systemctl start docker
```

## Install docker compose

# get the latest version for docker-compose
```
sudo curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) -o /usr/bin/docker-compose
```

# fix permissions after download:
```
sudo chmod +x /usr/bin/docker-compose
```

# verify the installation
```
sudo docker-compose version
```

## Step 3 - Download the Docker Compose File for Indexer Services

```
mkdir subquery-indexer & cd subquery-indexer
curl https://raw.githubusercontent.com/subquery/indexer-services/main/docker-compose.yml -o docker-compose.yml
```
IMPORTANT a) Please change the POSTGRES_PASSWORD in postgres service in docker_config.yml to your own password
          b) Please change postgres-password in coordinator-service in docker_config.yml to your own own password


## Step 4 - Start Indexer Services

Run the service using the following command:

```
sudo docker-compose up -d
```

It will start the following services:

- coordinator_db
- coordinator_service
- coordinator_proxy

Now, check the service status:

```
docker ps
```

## Step 5 - Set Up Auto Start

Create/etc/systemd/system/subquery.service

```
[Unit]
Description="Subquery systemd service"
After=network.target
StartLimitIntervalSec=0

[Service]
Type=simple
Restart=on-failure
RestartSec=10
User=root
SyslogIdentifier=subquery
SyslogFacility=local7
KillSignal=SIGHUP
WorkingDirectory=/root/subquery-indexer
ExecStart=/usr/bin/docker-compose up -d

[Install]
WantedBy=multi-user.target
```

Register and start the service by running:


```
systemctl enable subquery.service
systemctl start subquery.service
```

After that, verify that the service is running:


```
systemctl status subquery.service
```

## Connect to Metamask 

Add network details and connect your wallet to  https://frontier.subquery.network/explorer

## Request Testnet Tokens

Get ACA and SQL tokens using

!drip <metamask_wallet_address>  in #faucet channel


### Indexing your first project

## 1.1 The Indexer Admin Page

Navigate to http://<ip-address>:8000



