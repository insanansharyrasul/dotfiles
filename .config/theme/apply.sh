#!/usr/bin/env bash
# Generate terminal/btop colors from the palette in eww/eww.scss (single source of truth).
set -euo pipefail
self=$(dirname "$(readlink -f "$0")")
while IFS=': ' read -r name val; do
  v=${val%%;*}; export "${name#\$}=$v" "${name#\$}_x=${v#\#}"
done < <(grep -E '^\$[a-z0-9]+: #[0-9A-Fa-f]{6};' "$self/../eww/eww.scss")
vars='${background} ${base} ${surface} ${surface2} ${foreground} ${gray} ${accent} ${red} ${green} ${yellow} ${blue} ${magenta} ${accent_x} ${surface_x} ${base_x}'
c="$HOME/.config"
envsubst "$vars" < "$self/templates/alacritty.toml" > "$c/alacritty/colors.toml"
envsubst "$vars" < "$self/templates/kitty.conf"     > "$c/kitty/colors.conf"
envsubst "$vars" < "$self/templates/ghostty"        > "$c/ghostty/colors"
envsubst "$vars" < "$self/templates/btop.theme"     > "$c/btop/themes/eww.theme"
envsubst "$vars" < "$self/templates/colors.css"     > "$c/swaync/colors.css"
envsubst "$vars" < "$self/templates/colors.css"     > "$c/wofi/colors.css"
envsubst "$vars" < "$self/templates/hypr.lua"       > "$c/hypr/conf/colors.lua"
envsubst "$vars" < "$self/templates/hyprlock.conf"  > "$c/hypr/hyprlock-colors.conf"
envsubst "$vars" < "$self/templates/zathura"        > "$c/zathura/colors"
envsubst "$vars" < "$self/templates/posh.json"      > "$HOME/.poshthemes/ayu_eww.omp.json"
hyprctl reload >/dev/null 2>&1 || true
pkill -USR1 kitty || true   # alacritty reloads itself; ghostty: ctrl+shift+,
swaync-client -rs >/dev/null 2>&1 || true
