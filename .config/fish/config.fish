fish_vi_key_bindings

set fish_cursor_default block blink
set fish_cursor_insert line blink
set fish_cursor_replace_one underscore blink
set fish_cursor_visual block

oh-my-posh init fish --config $HOME/.poshthemes/ayu_custom.omp.json | source
alias vim nvim
alias vi nvim
alias p "ping www.google.com"
alias rsc "nmcli device wifi rescan && notify-send 'Wi-Fi Rescan' 'Rescanned Wi-Fi networks.'"
alias b "cd .."
alias td "cd ~/Downloads"

# Git aliases
alias g "git"
alias ga "git add"
alias gc "git commit"
alias gca "git commit --amend"
alias gco "git checkout"
alias gcm "git commit -m"
alias gcl "git clone"
alias gpl "git pull"
alias gp "git push origin"
alias gps "git push"

# if status is-interactive
    # Commands to run in interactive sessions can go here
# end

set fish_greeting

# >>> coursier install directory >>>
set -gx PATH "$PATH:/home/teaguy21/.local/share/coursier/bin"
# <<< coursier install directory <<<

set -x XDG_CURRENT_DESKTOP sway
