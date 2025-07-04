#!/bin/bash
# Rust Development Setup Script for Neovim

echo "Setting up Rust development environment for Neovim..."

# Install Rust if not already installed
if ! command -v rustc &> /dev/null; then
    echo "Installing Rust..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source "$HOME/.cargo/env"
else
    echo "Rust is already installed"
fi

# Update Rust to latest
echo "Updating Rust..."
rustup update

# Install rust-analyzer (LSP server)
echo "Installing rust-analyzer..."
rustup component add rust-analyzer

# Install clippy for linting
echo "Installing clippy..."
rustup component add clippy

# Install rustfmt for formatting
echo "Installing rustfmt..."
rustup component add rustfmt

# Install LLDB for debugging (required for DAP)
echo "Installing LLDB for debugging..."
if command -v apt &> /dev/null; then
    sudo apt update && sudo apt install -y lldb
elif command -v pacman &> /dev/null; then
    sudo pacman -S lldb
elif command -v yum &> /dev/null; then
    sudo yum install -y lldb
elif command -v dnf &> /dev/null; then
    sudo dnf install -y lldb
else
    echo "Please install LLDB manually for your distribution"
fi

# Install cargo-edit for better dependency management
echo "Installing cargo-edit..."
cargo install cargo-edit

# Install cargo-watch for file watching
echo "Installing cargo-watch..."
cargo install cargo-watch

echo ""
echo "Rust development setup complete!"
echo ""
echo "Next steps:"
echo "1. Open Neovim and run :PlugInstall to install plugins"
echo "2. Restart Neovim after plugin installation"
echo "3. Open a Rust file (.rs) to activate LSP"
echo ""
echo "Key bindings:"
echo "  <leader>rr  - Cargo run"
echo "  <leader>rt  - Cargo test"
echo "  <leader>rb  - Cargo build"
echo "  <leader>rc  - Cargo check"
echo "  <leader>rC  - Cargo clippy"
echo "  <leader>rf  - Cargo format"
echo "  <F5>        - Debug: Continue"
echo "  <F10>       - Debug: Step over"
echo "  <leader>db  - Toggle breakpoint"
echo ""
echo "Crates.nvim (for Cargo.toml):"
echo "  <leader>ct  - Toggle crates"
echo "  <leader>cu  - Update crate"
echo "  <leader>cv  - Show versions"
echo ""
