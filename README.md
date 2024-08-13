# Configurations

This repository represents my 'fail-safe' for swiftly setting up a desktop the way I like it. It acts as a hub for all the individual config-repositories for each application.


# Applications

### General Tools
|Name|Link| 
|:---|---:|
|Alacritty|https://alacritty.org/|
|Starship|https://starship.rs/|
|base16--shell|https://github.com/chriskempson/base16-shell|
|hyperfine|https://github.com/sharkdp/hyperfine|
|zellij|https://zellij.dev/|
|helix|https://helix-editor.com/|

### CFD Tools
|Name|Link|
|:---|---:|
|EllipSys2D|https://gitlab.windenergy.dtu.dk/EllipSys/ellipsys2d|
|EllipSys3D|https://gitlab.windenergy.dtu.dk/EllipSys/ellipsys3d|
|PGLW|https://gitlab.windenergy.dtu.dk/frza/PGL|
|Pointwise|https://www.cfd-technologies.co.uk/pointwise/|
|Fieldview|https://tecplot.com/products/fieldview/|
|Paraview|https://www.paraview.org/|

### Other
|Name|Link|
|:---|---:|
|Slack|https://slack.com/|
|Obsidian|https://obsidian.md/|
|Zoom|https://zoom.us/|
|Flameshot|https://flameshot.org/|
|Zotero|https://www.zotero.org/|
|i3|https://i3wm.org/|
|i3status-rs|https://github.com/greshake/i3status-rust|


# Color Scheme
I tend to prefer [Rose Pine](https://rosepinetheme) as my go-to color theme for _everything_, and where available, it has been applied.


# Installation

The installation progress here is described sequentially, and isolated steps might depend on preceeding commands or applications.

To begin, it is necessary to set-up `curl` and a SSH key pair.

## Setting up SSH

Upon reinstallation, first set-up a new SSH key pair for accessing github:
```bash
ssh-keygen -t rsa
```
and upload the public key to github. Subsequently, clone this repository using ssh:
```bash
git clone git@github.com:kristian-ebstrup/configs.git
```
and leave it for now, and instead first install the most important applications before linking config files.

### Accessing your private GitHub repos on the clusters

To set-up SSH access to a private account on github on the clusters (as github doesn't support pushing using https, apparently), it's necessary to generate a key pair on the cluster, and make sure to add it to the ssh-agent such that it is recognized as a private rather than public key.

The following instructions assumes being logged into a cluster:

1. Generate the key pair with a password and name that makes sense (e.g. `gbar_github` or `sophia_github`):
```bash
ssh-keygen -t ed25519
```
2. Upload the public key to your github account ([https://github.com/settings/keys]()).
3. Start `ssh-agent` and `ssh-add` the key (e.g. using `gbar_github`):
```bash
eval `ssh-agent -s`
ssh_add ~/.ssh/gbar_github
```
4. (Optional) For github repos cloned using https, `cd` into those repos and change the origin url to the ssh url. For example, for this repository:
```bash
git remote set-url origin git@github.com:kristian-ebstrup/configs.git
```

And that should do it.

## curl
Install `curl` using `apt`, as using `snap` causes some issues for `curl`:
```bash
$ sudo apt install curl
```

## General tools
The installation instructions for the general tools follows in this section. No special credentials are necessary to install and set-up the general tools using my configs.

### <a name="#rust"></a>Rust
```bash
$ curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```
For a convenient feature, also install cargo-watch:

```bash
$ cargo install cargo-watch
```

### <a name="#starship"></a>Starship
To install Starship, run the command
```bash
$ curl -sS https://starship.rs/install.sh | sh
```

### <a name="#alacritty"></a>Alacritty
Alacritty has a few dependencies, which should be easily installed by running the following:
```bash
$ sudo apt-get install cmake pkg-config libfreetype6-dev libfontconfig1-dev libxcb-xfixes0-dev libxkbcommon-dev python3
```

Once these dependencies are all downloaded and installed, Alacritty can easily be installed:
```bash
$ cargo install alacritty
```
but if there is an interest in a more involved installation process with more options, look [here](https://github.com/alacritty/alacritty/blob/master/INSTALL.md).

### <a name="#fzf"></a>fzf
```bash
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install
```

### [hyperfine](https://github.com/sharkdp/hyperfine)

```bash
$ wget https://github.com/sharkdp/hyperfine/releases/download/v1.15.0/hyperfine_1.15.0_amd64.deb
$ sudo dpkg -i hyperfine_1.15.0_amd64.deb
```

### <a name="#base16-shell"></a>base16-shell
```bash
$ git clone https://github.com/chriskempson/base16-shell.git ~/.config/base16-shell
``` 


## [PhD-related tools](https://gitlab.windenergy.dtu.dk/)
The installation instructions for the tools in this section assumes valid licenses and general access privileges (especially to the DTU Wind Energy gitlab site). As such, a general user is not expected to be able to have success following the instructions.

### <a name="#e2d"></a>[ellipsys2d](https://gitlab.windenergy.dtu.dk/EllipSys/ellipsys2d)
Clone the repo:
```bash
$ git clone https://gitlab.windenergy.dtu.dk/EllipSys/ellipsys2d.git
```
and follow the instructions in the readme.

### <a name="#e3d"></a>[ellipsys3d](https://gitlab.windenergy.dtu.dk/EllipSys/ellipsys3d)
Clone the repo:
```
git clone https://gitlab.windenergy.dtu.dk/EllipSys/ellipsys3d.git
```
and follow the instructions in the readme.

### <a name="#pgl"></a>[PGL](https://gitlab.windenergy.dtu.dk/frza/PGL)
Follow the instructions in the readme.

### <a name="#pointwise"></a>Pointwise
*TODO*

### <a name="#fieldview"></a>Fieldivew
*TODO*

### <a name="#paraview"></a>ParaView
Download the latest version from [here](https://www.paraview.org/download/), and install it to an appropiate folder.


## Other
### <a name="#slack"></a>Slack
```bash
snap install slack
```

### <a name="#zoom"></a>Zoom
```bash
snap install zoom-client
```

### <a name="#flameshot"></a>Flameshot
```bash
sudo apt install flameshot
```

To set-up hotkeys on KDE Plasma desktop, a configuration file is available on Flameshot's website. Simply follow the instructions, which are found [here](https://flameshot.org/docs/guide/key-bindings/).

### <a name="#zotero"></a>Zotero
Download Zotero from [here](https://www.zotero.org/download/).

https://github.com/greshake/i3status-rust
# Configurations

## Setting up config files
### Local
After everything is installed, make sure to symbolically link the configs to the git repo. Assuming the git repo is cloned to `$HOME/git/configs`, this is done by running the following command:
```bash
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
ln -s git/configs/.ssh/config .ssh/
```

To set Alacritty to open when pressing `Meta+Return` (or `Windows+Enter` on most keyboards), go to Custom Shortcuts (or similar, depending on your choice of distro) and add a new shortcut which points to `/home/$USER/.cargo/bin/alacritty`.

Set `caps lock` to be an extra `esc` for better flow in nvim in Keyboard -> Advanced.

(*Note: Currently depreciated in favour of `rsync`, and all mount commands are out-commented*) To use the mount commands (`mountg` and `mounts` for *mount gbar* and *mount sophia* respectively), make sure to make the directories beforehand:
```bash
mkdir /mnt/gdrive
mkdir /mnt/sdrive
``` 
Remember to use `umountg` and `umounts` to un-mount again before powering down.


## Printer
The printer server at Risø Campus is `\\ait-pprintri02.win.dtu.dk`. To setup a particular printer, simply use the built-in GUI, as demonstrated in the picture:
https://github.com/greshake/i3status-rust
![Windows Samba Printer Set-Up](printer_config.png)

To get a list of available printers, execute the following in a terminal:
```bash
$ smbclient -L //ait-pprintri02.win.dtu.dk/ -U kreb@dtu.dk
```
and input the password.

It is likely that you will have issues getting access to the server, with errors such as `NT_STATUS_ACCESS_DENIED`. In that case, go to `/etc/samba/smb.conf` and add the following lines under `[global]`:
```conf
client min protocol = SMB2
client max protocol = SMB3
```
This will force Samba to _not_ use SMB1, which it defaults to (and is disabled by campus network).
