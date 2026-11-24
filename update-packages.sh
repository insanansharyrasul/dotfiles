#!/usr/bin/env bash
# Regenerate packages/* from the current machine.
cd "$(dirname "$0")" && mkdir -p packages
apt-mark showmanual | sort > packages/apt.txt
npm ls -g --depth=0 --parseable 2>/dev/null | tail -n +2 | xargs -n1 basename > packages/npm.txt
cargo install --list 2>/dev/null | awk '/^[a-z]/{print $1}' > packages/cargo.txt
code --list-extensions > packages/vscode-extensions.txt 2>/dev/null
dconf dump / > packages/dconf.ini
