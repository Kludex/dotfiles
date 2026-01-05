#!/bin/sh

# Install Cargo (https://doc.rust-lang.org/cargo/getting-started/installation.html)
curl https://sh.rustup.rs -sSf | sh
source "$HOME/.cargo/env"

# Install Homebrew (https://brew.sh/)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install cmake (https://cmake.org/)
brew install cmake

# Instal Sheldon (https://sheldon.cli.rs/)
brew install sheldon

# Install uv (https://docs.astral.sh/uv/getting-started/installation/#homebrew)
brew install uv

# Install Starship (https://starship.rs/)
cargo install starship --locked

# Install NVM (https://github.com/nvm-sh/nvm)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.2/install.sh | bash
