#!/usr/bin/env bash
# Bootstrap: install packages, then link dotfiles. Run from ~/.dotfiles.
set -e
cd "$(dirname "$0")"
sudo apt install -y stow $(grep -vE '^(linux-|lib)' packages/apt.txt | tr '\n' ' ') || true
xargs -a packages/vscode-extensions.txt -n1 code --install-extension || true
dconf load / < packages/dconf.ini
stow -v .
