# Configuration Files
This repository contains my configuration files for the most critical applications used. Further, this readme contains a list of commonly used applications which are relevant to install after a potential reinstallation of a Debian-based distro.

# Applications
As part of recovering from a reinstallation of a Debian-based diistro, re-install the following:
- alacritty
- starship
- rust
- fzf
- base16
- tmux
- MATLAB
- EllipSys2D
- EllipSys3D
- PGL
- Pointwise
- FieldView
- ParaView
- hyperfine
- nvim
- zettler (or any other markdown editor)

# Installation
The installation progress here is described sequentially, and isolated steps might depend on preceeding commands or applications.

To begin, it is necessary to set-up `curl` and a SSH key pair.

### SSH
Upon reinstallation, first set-up a new SSH key pair for accessing github:
``` 
ssh-keygen -t rsa
```
and upload the public key to github. Subsequently, clone this repository using ssh:
```
git clone git@github.com:kristian-ebstrup/configs.git
```
and leave it for now, and instead first install the most important applications before linking config files.

### curl
Install `curl` using `apt`, as using `snap` causes some issues for `curl`:
```
sudo apt install curl
```

## Rust
```
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

## Starship
To install Starship, run the command
```
curl -sS https://starship.rs/install.sh | sh
```
The `.bashrc` file is already set-up to use Starship once it is installed.

## Alacritty
Alacritty has a few dependencies, which should be easily installed by running the following:
```
sudo apt-get install cmake pkg-config libfreetype6-dev libfontconfig1-dev libxcb-xfixes0-dev libxkbcommon-dev python3
```

Once these dependencies are all downloaded and installed, Alacritty can easily be installed:
```
cargo install alacritty
```
but if there is an interest in a more involved installation process with more options, look [here](https://github.com/alacritty/alacritty/blob/master/INSTALL.md).

## fzf
`sudo apt install fzf`


## [tmux](https://github.com/tmux/tmux/wiki)
`sudo apt install tmux`

## [neovim](https://github.com/neovim/neovim)
Download the newest (stable) version from [here](https://github.com/neovim/neovim/releases/tag/stable), and run
```
sudo apt install ./neovim-linux64.deb
```

## [hyperfine](https://github.com/sharkdp/hyperfine)

```
wget https://github.com/sharkdp/hyperfine/releases/download/v1.15.0/hyperfine_1.15.0_amd64.deb
sudo dpkg -i hyperfine_1.15.0_amd64.deb
```

# Configurations
After everything is installed, make sure to symbolically link the configs to the git repo. Assuming the git repo is cloned to `$HOME/git/configs`, run the following command:
```
cd $HOME
mkdir .config/alacritty
mkdir .config/nvim
mkdir .config/nvim/lua
ln -s git/configs/.config/alacritty/alacritty.yml .config/alacritty/
ln -s git/configs/.config/nvim/init.lua .config/nvim/
ln -s git/configs/.config/nvim/lua/plugins.lua .config/nvim/lua/
ln -s git/configs/.tmux.conf .
ln -s git/configs/.bashrc .
ln -s git/configs/.bash_aliases
```

To set Alacritty to open when pressing `Meta+Return` (or `Windows+Enter` on most keyboards), go to Custom Shortcuts and add a new shortcut which points to `/home/$USER/.cargo/bin/alacritty`.

Finally, remember to set `caps lock` to be `esc` for better flow in nvim.
