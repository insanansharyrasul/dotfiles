oh-my-posh init fish --config $HOME/.poshthemes/ayu_custom.omp.json | source
alias vim nvim
alias vi nvim
alias p "ping www.google.com"
alias rsc "nmcli device wifi rescan && notify-send 'Wi-Fi Rescan' 'Rescanned Wi-Fi networks.'"

# if status is-interactive
    # Commands to run in interactive sessions can go here
# end

set fish_greeting

# >>> coursier install directory >>>
set -gx PATH "$PATH:/home/teaguy21/.local/share/coursier/bin"
# <<< coursier install directory <<<

set -x XDG_CURRENT_DESKTOP sway
