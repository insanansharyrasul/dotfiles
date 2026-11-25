#!/usr/bin/env bash
# Regenerate packages/* from the current machine.
cd "$(dirname "$0")" && mkdir -p packages
apt-mark showmanual | sort > packages/apt.txt
npm ls -g --depth=0 --parseable 2>/dev/null | tail -n +2 | xargs -n1 basename > packages/npm.txt
cargo install --list 2>/dev/null | awk '/^[a-z]/{print $1}' > packages/cargo.txt
code --list-extensions > packages/vscode-extensions.txt 2>/dev/null
# Only these dconf paths. A full `dconf dump /` leaks Bluetooth MACs, reminders, recent paths.
for p in org/gnome/desktop/interface org/gnome/desktop/wm/preferences \
         org/gtk/settings/file-chooser org/gtk/gtk4/settings/file-chooser \
         org/nemo/preferences org/cinnamon/desktop/applications/terminal; do
  dconf dump "/$p/" | sed -E "s|^\[/\]$|[$p]|;t; s|^\[([^/].*)\]$|[$p/\1]|"
  echo
done > packages/dconf.ini
