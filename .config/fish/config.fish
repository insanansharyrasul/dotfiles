fish_vi_key_bindings

set fish_cursor_default block blink
set fish_cursor_insert line blink
set fish_cursor_replace_one underscore blink
set fish_cursor_visual block

# One letter alias
alias b "cd .."
alias c "clear"
alias d "apt update ; apt upgrade -y --allow-downgrades"
alias f "python3"
alias k "pkill"
alias p "ping www.google.com"
alias t "trans"
alias v "nvim"

oh-my-posh init fish --config $HOME/.poshthemes/ayu_eww.omp.json | source
alias vim nvim
alias vi nvim
alias rsc "nmcli device wifi rescan && notify-send 'Wi-Fi Rescan' 'Rescanned Wi-Fi networks.'"
alias td "cd ~/Downloads"
alias bldapk "flutter clean && flutter build apk --release && cp build/app/outputs/flutter-apk/app-release.apk ~/Downloads/"
alias sai "sudo apt install"
alias apt 'sudo apt-fast'
alias ntp "sudo ntpdate -s time.nist.gov"
alias qw "pkill java && pkill qemu && pkill adb && pkill dart"

# config aliases
alias dotfc "cd ~/.config/hypr ; vim"
alias fishc "vim ~/.config/fish/config.fish"
alias monitorc "vim ~/.config/hypr/monitors.lua"

# Git aliases
alias ga "git add"
alias gc "git commit -m"
alias gca "git commit --amend"
alias gco "git checkout"
alias gcl "git clone"
alias gpl "git pull"
alias gp "git push origin"
alias gps "git push"
alias gs "git status"
alias gd "git diff"
alias gl "git log"
alias gst "/usr/bin/gs"

# pnpm
set -gx PNPM_HOME "$HOME/.local/share/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end

bind -M insert \t accept-autosuggestion
bind -M insert \e\[Z complete

# g++-14
set -Ux CC gcc-14
set -Ux CXX g++-14
set -gx LANG en_US.UTF-8
set -gx LC_ALL en_US.UTF-8
set -gx PATH "$HOME/.local/bin" $PATH
set -gx ANDROID_HOME $HOME/Android/Sdk
set -gx ANDROID_SDK_ROOT $ANDROID_HOME
set -gx PATH "$PATH:$HOME/.local/share/coursier/bin"
set -gx PATH "$HOME/.rive/bin:$PATH"
set fish_greeting

fish_add_path \
    $ANDROID_HOME/platform-tools \
    $ANDROID_HOME/emulator \
    $ANDROID_HOME/cmdline-tools/latest/bin
fish_add_path $HOME/.opencode/bin
fish_add_path -g "$HOME/.kimi-code/bin"
fish_add_path -g "$HOME/.maestro/bin"
fish_add_path -g "$HOME/.bun/bin"

function notify_on_complete --on-event fish_postexec
    set -l threshold 5000
    set -l ignore claude opencode nvim vim yazi y ssh htop btop lazygit less man

    if test -n "$CMD_DURATION" -a $CMD_DURATION -ge $threshold
        set -l words (string split ' ' -- (string replace -r '^sudo\s+' '' -- "$argv"))
        contains -- $words[1] $ignore; and return

        if type -q hyprctl
            set -l win (hyprctl activewindow -j 2>/dev/null | jq -r '.pid // empty')
            set -l p $fish_pid
            while test -n "$win" -a "$p" -gt 1
                test "$p" = "$win"; and return
                set p (string trim (ps -o ppid= -p $p))
            end
        end

        set -l duration_sec (math -s1 "$CMD_DURATION / 1000")
        set -l title "Command Finished"
        set -l msg "\"$argv\" completed in $duration_sec s"

        if type -q notify-send
            notify-send -u normal $title $msg
        end
    end
end

function g -d "Git add, commit, and push"
    git add .
    git commit -m "$argv[1]"
    git push origin
end

function fc -d "Compile and run a C file"
    set base_name (basename $argv[1] .c)
    gcc $argv[1] -o $base_name; and ./$base_name
end

zoxide init fish | source

# Machine-specific settings, not committed.
test -f ~/.config/fish/local.fish; and source ~/.config/fish/local.fish
