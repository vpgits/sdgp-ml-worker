#!/bin/bash

set -e

apt-get update && apt-get upgrade -y 
apt-get install -y --no-install-recommends software-properties-common curl git
curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | bash
apt-get install git-lfs
mkdir -p $HOME/.ssh
chmod 700 $HOME/.ssh
echo "Adding private key to $HOME/.ssh/"
echo "$HUGGINGFACE_SSH_PRIVATE_KEY" > /root/.ssh/id_ed25519
chmod 600 $HOME/.ssh/id_ed25519
ssh-keyscan hf.co >> ~/.ssh/known_hosts
echo "attempting to clone the model repo"
cd src && git clone git@hf.co:vpgits/Mistral-7B-v0.1-qagen-v2.1-AWQ
echo "model cloned successfull

