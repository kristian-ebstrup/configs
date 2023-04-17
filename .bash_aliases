# Kristian Ebstrup Jacobsens' Aliases
# Jan 2023

# ------------- #
# SCP/SSH ALIASES
# ------------- #
# ssh short-cuts
alias sophia='ssh -X kreb@sophia1.hpc.ait.dtu.dk'
alias gbar='ssh -X kreb@login.gbar.dtu.dk -i ~/.ssh/id_gbar'

# VPN short-cut
alias vpn='sudo openconnect --user=kreb --os=win extra-vpn.ait.dtu.dk'

# Sophia mnt solution (Sergio)
alias mounts='sudo sshfs -o allow_other,IdentityFile=/home/kreb/.ssh/id_rsa kreb@sophia1.hpc.ait.dtu.dk:/ /mnt/sdrive'
alias umounts='sudo umount -l /mnt/sdrive'
alias shome='cd /mnt/sdrive/home/kreb'

# gbar mnt solution
alias mountg='sudo sshfs -o allow_other,IdentityFile=/home/kreb/.ssh/id_gbar kreb@login1.gbar.dtu.dk:/ /mnt/gdrive' 
alias umountg='sudo umount -l /mnt/gdrive'
alias ghome='cd /mnt/gdrive/zhome/e9/6/145232/'

# scp up/down aliases
gup() {
  scp -i /home/kreb/.ssh/id_gbar -r $1 kreb@transfer.gbar.dtu.dk:~/$2
}
gdown() {
  scp -i /home/kreb/.ssh/id_gbar -r kreb@transfer.gbar.dtu.dk:~/$1 $2
}
sup() {
  scp -r $1 kreb@sophia1.hpc.ait.dtu.dk:~/$2
}
sdown() {
  scp -r kreb@sophia1.hpc.ait.dtu.dk:~/$1 $2
}


# ---------------------------------------- #
# UTILITY ALIASES
# https://github.com/kristian-ebstrup/utils
# ---------------------------------------- #
alias rst2pv='/home/kreb/git/utils/postprocessing/postprocess_timeseries.sh'


# ------------- #
# MISC. ALIASES
# ------------- #

# Paraview
alias pv='/home/kreb/ParaView-5.11.0-MPI-Linux-Python3.9-x86_64/bin/paraview'

# Set nvim to start when calling vim
alias vim='/usr/bin/nvim'

# Alias tmux to ensure 256 colors
alias tmux='TERM=xterm-256color tmux'

# Quick cd using fzf
alias sd="cd ~ && cd \$(find * -type d | fzf)"

# Shortcut to open Zettlr in phd-documentation folder
alias zettlr="Zettlr /home/kreb/git/personal/phd-documentation"

# ----------------------- #
# STANDARD BASHRC ALIASES
# ----------------------- #

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alFh --group-directories-first'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# ----------------------- #
# CURRENTLY UNUSED ALIASES
# ----------------------- #

# Mads' .bashrc EllipSys compiler
# ce1d() { CWD=$(pwd); cd ~/git/cfd_tools/ellipsys/ellipsys1d/ellipsys1d/Executables/; make -f flowfield.mkf ; cd $CWD; }

# Mads' EllipSys runner
# alias flo='rm grid.points; flowfield input.dat > log.txt'

# MATLAB shortcut
#alias matlab='/usr/local/MATLAB/R2022b/bin/matlab'
