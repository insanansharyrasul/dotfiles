#!/usr/bin/env bash
# Generate terminal/btop colors from the palette in eww/eww.scss (single source of truth).
set -euo pipefail
self=$(dirname "$(readlink -f "$0")")
while IFS=': ' read -r name val; do
  export "${name#\$}=${val%%;*}"
done < <(grep -E '^\$[a-z0-9]+: #[0-9A-Fa-f]{6};' "$self/../eww/eww.scss")
vars='${background} ${base} ${surface} ${surface2} ${foreground} ${gray} ${accent} ${red} ${green} ${yellow} ${blue} ${magenta}'
c="$HOME/.config"
envsubst "$vars" < "$self/templates/alacritty.toml" > "$c/alacritty/colors.toml"
envsubst "$vars" < "$self/templates/kitty.conf"     > "$c/kitty/colors.conf"
envsubst "$vars" < "$self/templates/ghostty"        > "$c/ghostty/colors"
envsubst "$vars" < "$self/templates/btop.theme"     > "$c/btop/themes/eww.theme"
envsubst "$vars" < "$self/templates/colors.css"     > "$c/swaync/colors.css"
envsubst "$vars" < "$self/templates/colors.css"     > "$c/wofi/colors.css"
pkill -USR1 kitty || true   # alacritty reloads itself; ghostty: ctrl+shift+,
swaync-client -rs >/dev/null 2>&1 || true
