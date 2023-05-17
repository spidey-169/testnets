#!/bin/bash

function setup {
  version "${1}"
  gopath "${2}"
}

function version {
  VERSION=${1:-"1.20.2"}
}

function gopath {
  GOPATH=${1:-"$HOME/go"}
}

function line {
echo "-------------------------------------------------------------------"
}

function components {
    line
    echo -e "$YELLOW Components installing... $NORMAL"
    line
    sudo apt update && sudo apt upgrade -y
    sudo apt-get install build-essential automake autoconf libtool wget curl libssl-dev git cmake perl tmux ufw gcc unzip zip jq make -y
    sudo apt-get install golang-statik -y
    line
    echo -e "$GREEN Components installed... $NORMAL"
    line
}

function goInstall {
    line
    echo -e "$YELLOW GOLANG ${VERSION} installing... $NORMAL"
    line
    echo -e "$YELLOW :: Downloading GO archive...$NORMAL"
    wget "https://golang.org/dl/go${VERSION}.linux-amd64.tar.gz" 
    sudo tar -C /usr/local -xzf "go${VERSION}.linux-amd64.tar.gz" 
    rm "go${VERSION}.linux-amd64.tar.gz" 
    sudo chmod 755 /usr/local/go
    line
    echo -e "$GREEN GOLANG ${VERSION} installed... $NORMAL"
    line
}


function env {
    sudo sh -c "echo 'export PATH=\$PATH:/usr/local/go/bin:$HOME/go/bin' >> $HOME/.bash_profile"
    source $HOME/.bash_profile
    mkdir -p ${GOPATH}{,/bin,/pkg,/src}
    line
    echo -e "$GREEN Env installed... $NORMAL"
    line
}

function launch {
setup "${1}" "${2}"
components
GO="$(which go)"
GOFMT="$(which gofmt)"
GOVERSION="$($(which go) version)"
if [ -f "$GO" ]; then
    line
    echo -e "$YELLOW Found an ${GOVERSION} in your system. Choose an option:$NORMAL"
    echo -e "$RED 1$NORMAL -$YELLOW Reinstall Golang.$NORMAL"
    echo -e "$RED 2$NORMAL -$YELLOW Do nothing.$NORMAL"
    line
    read -p "Your answer: " ANSWER
    if [ "$ANSWER" == "1" ]; then
        rm -rf /usr/local/go
        mkdir -p /usr/local/go
        goInstall
        env
        GOVERSION="$($(which go) version)"
        line
        echo -e "$GREEN ${GOVERSION} installed... $NORMAL"
        line
    elif [ "$ANSWER" == "2" ]; then
        line
        echo -e "$YELLOW The option to do nothing is selected. Continue...$NORMAL"
        line
    fi
else
    goInstall
    env
    GOVERSION="$($(which go) version)"
    line
    echo -e "$GREEN ${GOVERSION} instaled... $NORMAL"
    line
fi
}

while getopts ":v:p::" o; do
  case "${o}" in
    v)
      v=${OPTARG}
      ;;
    p)
      p=${OPTARG}
      ;;
  esac
done
shift $((OPTIND-1))

launch "${v}" "${p}"
