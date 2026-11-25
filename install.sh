#!/usr/bin/env bash
# Bootstrap: install packages, fonts and cursor, then link dotfiles. Run from ~/.dotfiles.
set -e
cd "$(dirname "$0")"
sudo apt install -y stow $(grep -vE '^(linux-|lib)' packages/apt.txt | tr '\n' ' ') || true
xargs -a packages/vscode-extensions.txt -n1 code --install-extension || true
dconf load / < packages/dconf.ini
stow -v .

# Fonts and cursor are downloaded, not committed (they made the repo 150 MB).
fonts=~/.local/share/fonts; icons=~/.local/share/icons
mkdir -p "$fonts" "$icons"
for f in JetBrainsMono FiraCode RobotoMono; do
  [ -d "$fonts/$f" ] || { mkdir -p "$fonts/$f"; curl -fsSL "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/$f.tar.xz" | tar -xJ -C "$fonts/$f"; }
done
fc-cache -f "$fonts"
[ -d "$icons/Bibata-Modern-Classic" ] || curl -fsSL https://github.com/ful1e5/Bibata_Cursor/releases/latest/download/Bibata-Modern-Classic.tar.xz | tar -xJ -C "$icons"

# Fish plugins from fish_plugins
fish -c 'curl -fsSL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher update' || true

systemctl --user enable kanata.service swww.service || true
