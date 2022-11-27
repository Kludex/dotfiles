#!/bin/sh

# Install Essentials
sudo apt install build-essential pkg-config libssl-dev curl

# Install Cargo
curl https://sh.rustup.rs -sSf | sh

# Install NVM
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.2/install.sh | bash

