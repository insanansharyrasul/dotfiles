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
alias bf "flutter clean && flutter build apk --release && cp build/app/outputs/flutter-apk/app-release.apk ~/Downloads/"

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

function gall -d "Git add, commit, and push"
    git add .
    git commit -m "$argv[1]"
    git push origin
end

# Alias for killing processes
alias qw "pkill java && pkill qemu"

# if status is-interactive
    # Commands to run in interactive sessions can go here
# end

set fish_greeting

# >>> coursier install directory >>>
set -gx PATH "$PATH:/home/teaguy21/.local/share/coursier/bin"
# <<< coursier install directory <<<

set -x XDG_CURRENT_DESKTOP sway

# pnpm
set -gx PNPM_HOME "/home/teaguy21/.local/share/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end
