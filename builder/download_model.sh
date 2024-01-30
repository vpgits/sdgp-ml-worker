#!/bin/bash -x

set -e

apt-get update && apt-get upgrade -y 
apt-get install -y --no-install-recommends software-properties-common curl git
curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | bash
apt-get install git-lfs
echo "Setting up Git credentials"
echo "GH_ORG: $GH_ORG"
echo "GH_EMAIL: $GH_EMAIL"
git config --global credential.helper store # Use git credential store to remember credentials
git config --global user.name "$GH_ORG"   # Replace with your Git username
git config --global user.email "$GH_EMAIL" # Replace with your Git email
echo "Git credentials set up."
git config --list
echo "attempting to clone the model repo"
mkdir -p /src # Ensure src directory exists
cd /src
git clone https://"$GH_ORG":"$HUGGINGFACE_PAT"@huggingface.co/vpgits/Mistral-7B-v0.1-qagen-v2.1-AWQ
echo "model cloned successfully"
apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/*