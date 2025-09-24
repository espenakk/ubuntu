
alias rdp='xfreerdp /v:192.168.10.152 /u:rune /dynamic-resolution /f +clipboard /sound:sys:pulse /cert:ignore'
alias wgup='sudo wg-quick up pandovpn'
alias wgdown='sudo wg-quick down pandovpn'
alias wgup2='nmcli connection up pandovpn'
alias wgdown2='nmcli connection down pandovpn'
alias srcros='source /opt/ros/jazzy/setup.bash'
alias srcrosloc='source install/local_setup.bash'

# File system
alias ls='eza -lh --group-directories-first --icons=auto'
alias lsa='ls -a'
alias lt='eza --tree --level=2 --long --icons --git'
alias lta='lt -a'
alias ff="fzf --preview 'bat --style=numbers --color=always {}'"
alias cd="zd"
alias cat="batcat"
alias grep='grep --color=auto'


zd() {
  if [ $# -eq 0 ]; then
    builtin cd ~ && return
  elif [ -d "$1" ]; then
    builtin cd "$1"
  else
    z "$@" && printf "\U000F17A9 " && pwd || echo "Error: Directory not found"
  fi
}
open() {
  xdg-open "$@" >/dev/null 2>&1 &
}

