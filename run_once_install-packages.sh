#!/bin/sh

# Install Essentials
sudo apt install build-essential pkg-config libssl-dev curl gh

# Install Cargo (https://doc.rust-lang.org/cargo/getting-started/installation.html)
curl https://sh.rustup.rs -sSf | sh
source "$HOME/.cargo/env"

# Install Sheldon (https://sheldon.cli.rs/)
if [ "$(uname)" == "Darwin" ]; then
    brew install cmake
    brew install sheldon
    brew install pyenv
else
    cargo install sheldon
    curl https://pyenv.run | bash
fi

# Install Starship (https://starship.rs/)
cargo install starship --locked

# Install NVM (https://neovim.io/)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.2/install.sh | bash
