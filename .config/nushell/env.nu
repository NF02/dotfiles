# ░█▀▀░█▀█░█░█░░░░█▀█░█░█
# ░█▀▀░█░█░▀▄▀░░░░█░█░█░█
# ░▀▀▀░▀░▀░░▀░░▀░░▀░▀░▀▀▀

alias ll = ls -l
alias .. = cd ..
alias ... = cd ../..
alias mkd = mkdir
alias yt = yt-dlp --embed-metadata -i
alias yta = yt -x -f bestaudio/best
alias ytt = yt --skip-download --write-thumbnail
alias ffmpeg = ffmpeg -hide_banner

alias rm = rm --trash

alias pS = sudo pacman -S
alias pSy = sudo pacman -Syu
alias pR = sudo pacman -Rs

$env.PATH = ($env.PATH | split row (char esep) | prepend $"($env.HOME)/.local/bin")

