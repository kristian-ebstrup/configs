# Kristian Ebstrup Jacobsens' Aliases
# Jan 2023

# ---------------------------------------------------- #
# SCP/SSH ALIASES
# ---------------------------------------------------- #

# Sophia mount solution (modified from Sergio)
alias sophia_mount='sudo sshfs -o reconnect,allow_other,IdentityFile=/home/kreb/.ssh/id_sophia kreb@sophia1.hpc.ait.dtu.dk: /mnt/'
alias sophia_umount='sudo fusermount -u /mnt/'

# ssh short-cuts
alias sophia='ssh -X -o IdentityFile=/home/kreb/.ssh/id_sophia kreb@sophia1.hpc.ait.dtu.dk'
alias gbar='ssh -X kreb@login.gbar.dtu.dk'

# VPN short-cut
alias vpn='sudo openconnect --user=kreb --useragent=AnyConnect --os=win extra-vpn.ait.dtu.dk'


# rsync up/down aliases (maintains links)
gup() {
  rsync --progress -avhe ssh $1 kreb@transfer.gbar.dtu.dk:$2
}
gdown() {
  rsync --progress -avhe ssh kreb@transfer.gbar.dtu.dk:$1 $2
}
sup() {
  rsync --progress -avhe ssh $1 kreb@sophia1.hpc.ait.dtu.dk:$2
}
sdown() {
  rsync --progress -avhe ssh kreb@sophia1.hpc.ait.dtu.dk:$1 $2
}


# ---------------------------------------------------- #
# UTILITY ALIASES/FUNCTIONS
# https://github.com/kristian-ebstrup/utils
# ---------------------------------------------------- #
rst2pv() {
  /home/kreb/git/utils/postprocessing/rst2pv.sh "$@"
}

gridc() {
  /home/kreb/git/utils/postprocessing/gridc.sh
}

gridr() {
  /home/kreb/git/utils/postprocessing/gridr.sh
}


# ---------------------------------------------------- #
# CFD TOOLS
# ---------------------------------------------------- #

# Paraview
alias pv='/home/kreb/apps/ParaView-5.12.0-RC1-MPI-Linux-Python3.10-x86_64/bin/paraview'

# Pointwise
#alias pointwise='/home/kreb/apps/pointwise/Pointwise2022.2.1/pointwise'

# 2D mesh plotting
#alias pltgrid='/home/kreb/git/ellipsys/pltgrid/drawgrid; /home/kreb/git/ellipsys/pltgrid/hpglview grid.plt'

# Hypgrid + pltgrid
#alias hypplt='/home/kreb/git/ellipsys/hypgrid2d/hypgrid; pltgrid'

# ---------------------------------------------------- #
# MISC. ALIASES
# ---------------------------------------------------- #

# Zotero
alias zotero='/home/kreb/apps/Zotero_linux-x86_64/zotero'

# Set nvim to start when calling vim
alias vim='/home/kreb/apps/nvim-linux64/bin/nvim'

# Alias tmux to ensure 256 colors
alias tmux='TERM=xterm-256color tmux'

# overwrite xclip for easier piping
alias xclip='xclip -selection c'

# start jupyter lab
alias jlab='jupyter lab --ContentsManager.allow_hidden=True'

# change monitor setup
alias i3m='/home/kreb/.config/i3/i3_monitor_setups.sh'


# ---------------------------------------------------- #
# STANDARD BASHRC ALIASES
# ---------------------------------------------------- #

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='lsd --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -lFh --group-directories-first'
alias la='ls -lFhA --group-directories-first'
alias l='ls -F'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# ---------------------------------------------------- #
# CURRENTLY UNUSED ALIASES
# ---------------------------------------------------- #
#
## Sophia mnt solution (Sergio)
# alias mounts='sudo sshfs -o allow_other,IdentityFile=/home/kreb/.ssh/id_rsa kreb@sophia1.hpc.ait.dtu.dk:/ /mnt/sdrive'
# alias umounts='sudo umount -l /mnt/sdrive'
# alias shome='cd /mnt/sdrive/home/kreb'
#
## gbar mnt solution
# alias mountg='sudo sshfs -o allow_other,IdentityFile=/home/kreb/.ssh/id_gbar kreb@login1.gbar.dtu.dk:/ /mnt/gdrive' 
# alias umountg='sudo umount -l /mnt/gdrive'
# alias ghome='cd /mnt/gdrive/zhome/e9/6/145232/'
