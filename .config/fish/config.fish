oh-my-posh init fish --config $HOME/.poshthemes/montys.omp.json | source
alias vim nvim
alias vi nvim

# if status is-interactive
    # Commands to run in interactive sessions can go here
# end

set fish_greeting

# >>> coursier install directory >>>
set -gx PATH "$PATH:/home/teaguy21/.local/share/coursier/bin"
# <<< coursier install directory <<<
