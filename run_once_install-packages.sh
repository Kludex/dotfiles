#!/bin/sh

# Install Cargo (https://doc.rust-lang.org/cargo/getting-started/installation.html)
curl https://sh.rustup.rs -sSf | sh
source "$HOME/.cargo/env"

# Install Homebrew (https://brew.sh/)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Add Homebrew to PATH for the rest of this script (macOS and Linux locations)
if [ -x /opt/homebrew/bin/brew ]; then
	eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -x /usr/local/bin/brew ]; then
	eval "$(/usr/local/bin/brew shellenv)"
elif [ -x /home/linuxbrew/.linuxbrew/bin/brew ]; then
	eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

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

# Install GitHub CLI (https://cli.github.com/)
brew install gh

# Install Claude Code (https://docs.claude.com/en/docs/claude-code/setup)
curl -fsSL https://claude.ai/install.sh | bash

# Install peon-ping (https://github.com/PeonPing/peon-ping)
brew install PeonPing/tap/peon-ping
