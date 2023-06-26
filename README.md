# Configuration Files
This repository contains my configuration files for the most critical applications used. Further, this readme contains a list of commonly used applications which are relevant to install after a potential reinstallation of a Debian-based distro.

# Applications
As part of recovering from a reinstallation of a Debian-based distro, re-install the following:

*General tools*
- [Alacritty](#alacritty)
- [Starship](#starship)
- [Rust](#rust)
- [fzf](#fzf)
- [base16-shell](#base16-shell)
- [tmux](#tmux)
- [hyperfine](#hyperfine)
- [neovim](#neovim)

*PhD-related tools*
- [MATLAB](#matlab)
- [EllipSys2D](#e2d)
- [EllipSys3D](#e3d)
- [PGL](#pgl)
- [Pointwise](#pointwise)
- [FieldView](#fieldview)
- [ParaView](#paraview)

*Other*
- [Slack](#slack)
- [Zettlr](#zettlr)
- [Zoom](#zoom)
- [Flameshot](#flameshot)
- [Zotero](#zotero)


# Installation

The installation progress here is described sequentially, and isolated steps might depend on preceeding commands or applications.

To begin, it is necessary to set-up `curl` and a SSH key pair.

## Setting up SSH

Upon reinstallation, first set-up a new SSH key pair for accessing github:
```bash
$ ssh-keygen -t rsa
```
and upload the public key to github. Subsequently, clone this repository using ssh:
```bash
$ git clone git@github.com:kristian-ebstrup/configs.git
```
and leave it for now, and instead first install the most important applications before linking config files.

### Accessing your private GitHub repos on the clusters

To set-up SSH access to a private account on github on the clusters (as github doesn't support pushing using https, apparently), it's necessary to generate a key pair on the cluster, and make sure to add it to the ssh-agent such that it is recognized as a private rather than public key.

The following instructions assumes being logged into a cluster:

1. Generate the key pair with a password and name that makes sense (e.g. `gbar_github` or `sophia_github`):
```bash
$ ssh-keygen -t ed25519
```
2. Upload the public key to your github account ([https://github.com/settings/keys]()).
3. Start `ssh-agent` and `ssh-add` the key (e.g. using `gbar_github`):
```bash
$ eval `ssh-agent -s`
$ ssh_add ~/.ssh/gbar_github
```
4. (Optional) For github repos cloned using https, `cd` into those repos and change the origin url to the ssh url. For example, for this repository:
```bash
$ git remote set-url origin git@github.com:kristian-ebstrup/configs.git
```

And that should do it.

## Using SSH to access clusters without VPN

To access DTU's clusters (gbar or sophia) remotely without needing to rely on VPN, it is necessary to generate an `ed25519` SSH key pair with a password, and copy the public key to `$HOME/.ssh/authorized_keys` on the cluster of interest. As such, this set-up requires being on DTU's network to set-up for this remote access.

First generate the key pair:
```bash
$ ssh-keygen -t ed25519
```
and make sure to set-up a password for this key, and ideally name it e.g. `id_gbar` or `id_sophia` (as this is the names used in the current config files). Subsequently, copy-paste the public key into the `authorized_keys` on the cluster: 

```bash
$ cd ~/.ssh
$ touch authorized_keys
$ cat id_gbar.pub >> authorized_keys
$ scp authorized_keys kreb@transfer.gbar.dtu.dk:~/.ssh/
```

For sophia, simply replace `id_gbar.pub` with `id_sophia.pub`, and the hostname with `kreb@sophia1.hpc.ait.dtu.dk`.

Alternatively, `cat` directly by piping the output to `ssh`:

```bash
$ cat ~/.ssh/id_gbar.pub | ssh kreb@transfer.gbar.dtu.dk: "cat >> ~/.ssh/authorized_keys"
```

or using `xclip`:

```bash
$ cat ~/.ssh/id_gbar.pub | xclip -selection c
$ xclip -selection c -o | ssh kreb@transfer.gbar.dtu.dk: "cat >> ~/.ssh/authorized_keys"
```

### curl
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
The `.bashrc` file is already set-up to use Starship once it is installed. For gbar and Sophia, it can be necessary to get the binary through `cargo`.

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


### <a name="#tmux"></a>[tmux](https://github.com/tmux/tmux/wiki)
```bash
$ sudo apt install tmux
```

### <a name="#neovim"></a>[neovim](https://github.com/neovim/neovim)

#### Setting up locally
Locally, download the newest (stable) version from [here](https://github.com/neovim/neovim/releases/tag/stable), and run
```bash
$ sudo apt install ./neovim-linux64.deb
```

#### Set-up on Sophia
If trying to set-up on a remote server without `sudo` access, the set-up is a bit more complicated, as we need to build and install Neovim ourselves. A step-by-step guide that worked for me on Sophia follows:

1. Clone the Neovim repository to folder of choice
```bash
$ git clone https://github.com/neovim/neovim
```
2. Load required modules for compilation:
```bash
$ module load GCC/12.2.0 && module load CMake/3.24.3-GCCcore-12.2.0
```
3. Move into the git repo and build for Sophia:
```bash
$ cd neovim && make CMAKE_BUILD_TYPE=RelWithDebInfo CMAKE_INSTALL_PREFIX=/home/USER/.local/share/nvim
```
4. Install to the location specified in the above build:
```bash
make install
```

Ideally, this should set-up Neovim on Sophia, and your local config file _should_ work on Sophia as well.

#### Set-up on gbar
Similarly to Sophia, setting Neovim up on gbar can be a bit finicky. Here's a step-by-step guide that worked for me on gbar:

1. Clone the Neovim repository to folder of choice:
```bash
$ git clone https://github.com/neovim/neovim
```
2. Load required modules for compilation:
```bash
$ module load gcc/12.2.0 && module load cmake/3.26.3 && module load gcc/12.2.0-binutils-2.39
```
3. Save an environment variable to the loaded GNU compiler:
```bash
$ CC=/appl/gcc/12.2.0-binutils-2.39/bin/gcc
```
5. Force `cmake` to use this compiler replacing `${CMAKE_C_COMPILER}` with `${CC}` in `CMakeLists.txt`, as otherwise an out-dated compiler will be used without some necessary standard libraries. 
6. Move into the git repo and build for gbar:
```bash
$ cd neovim && make CMAKE_BUILD_TYPE=RelWithDebInfo CMAKE_INSTALL_PREFIX=$HOME/.local/share/nvim
```
7. Install to the location specified in the above build:
```bash
$ make install
```

#### Plugins
To install Neovim plugins, first install [Packer](https://github.com/wbthomason/packer.nvim) as the plug-in manager:
```bash
$ git clone --depth 1 https://github.com/wbthomason/packer.nvim\
   ~/.local/share/nvim/site/pack/packer/start/packer.nvim
```
Subsequently, open Neovim (e.g. by typing `nvim` in the terminal) and input `:PackerInstall` to automatically install the plugins included in `plugins.lua`.

The language server protocols (LSPs) used in this config is [rust-tools](https://github.com/simrat39/rust-tools.nvim), which uses [rust-analyzer](https://rust-analyzer.github.io/manual.html#installation). and [jedi-language-server](https://github.com/pappasam/jedi-language-server). Furthermore, the [Black](https://github.com/psf/black) formatter is used for Python formatting.

To set-up rust-analyzer, simply run the following commands:
```bash
$ mkdir -p ~/.local/bin
$ curl -L https://github.com/rust-lang/rust-analyzer/releases/latest/download/rust-analyzer-x86_64-unknown-linux-gnu.gz | gunzip -c - > ~/.local/bin/rust-analyzer
$ chmod +x ~/.local/bin/rust-analyzer
```
and it should be all set. Although, if it doesn't work, make sure that `~/.local/bin/` is in your `$PATH` environment variable.

<------------------------------------------------------------------->
DEPRECIATED; NEEDS TO BE CORRECTED (new LSP set-up! GBAR needs specific help for compiling treesitter)
(GBAR: to compile treesitter, one needs to add "require("nvim-treesitter.install").compilers={"gcc"}" to the
init.lua, while also loading the most recent gcc compiler. This is likely the same on Sophia)
SIMILARLY: Explain how to set up the Black, Rustfmt, Stylua
(```
cargo install rustfmt
cargo install stylua
pip install black
```)
MAYBE MAKE A GENERAL SET-UP, FOLLOWED BY A GBAR AND SOPHIA SET-UP, RATHER THAN INTERWEAVING
IF PACKER COMPLAINS ABOUT THE TABLE IS NUL, RUN :PackerCompile

To set-up jedi-language-server, simply run the following commands:
```bash
$ sudo apt install pipx
$ pipx install jedi-language-server
$ pipx ensurepath
```
pipx is a "global" variant of pip, and allows access to jedi-language-server across all virtual environments. In case of setting up Neovim on a remote server (e.g. Sophia), `sudo` is not an option, and each virtual environment needs to have jedi-language-server installed.

To set-up Black, create a virtual environment for Neovim:
```bash
$ mkdir ~/.local/venv
$ cd ~/.local/venv
$ python -m venv nvim
$ source nvim/bin/activate
$ pip install neovim
$ pip install black
```
The current config file for Neovim looks for this virtual environment by default.

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

### <a name="#matlab"></a>MATLAB
Log-on to the [MATLAB terminal for DTU](https://se.mathworks.com/academia/tah-portal/danmarks-tekniske-universitet-870549.html) and download the zip file containing the installer, and extract it, e.g. using unzip:
```bash
cd /home/$USER/Downloads/   
sudo unzip -X -K -d matlab matlab_R2022b_glnxa64.zip
```
and from here, move into the subdirectory and run `install`:
```bash
cd matlab
install
```
and follow the instructions.

If this produces the following error:
```bash
/home/$USER/Downloads/matlab/bin/glnxa64/MathWorksProductInstaller: error while loading shared libraries: /home/kreb/Downloads/matlab/bin/glnxa64/libexpat.so.1: file too short
```
make sure that the `unzip` command is executed with root privileges (i.e. `sudo`) and the `-X -K` flags. Note that _personally_, I cannot get it to work, and have abandoned all hope of getting it to work on Ubuntu.

### <a name="#pointwise"></a>Pointwise
*TODO*

### <a name="#fieldview"></a>Fieldivew
*TODO*

### <a name="#paraview"></a>ParaView
Download the latest version from [here](https://www.paraview.org/download/), and install it to an appropiate folder.

Subsequently, clone the latest Kenneth Lønbæk's plug-in for Paraview from [here](https://gitlab.windenergy.dtu.dk/kenloen/ellipsys_paraview_plugin), e.g. in the plugins folder in ParaView. Then, open up ParaView, go to `Tools -> Manage Plugins -> Load New` and select the Python script in `ellipsys_paraview_plugin`. This plug-in allows direct import of the .RST.01 files without postprocessing.

Make sure to activate automatic loading of the plug-in.

## Other
### <a name="#slack"></a>Slack
```bash
snap install slack
```

### <a name="#zettlr"></a>zettlr
Download the installer from [their website](https://www.zettlr.com/download/linux), and then simply navigate to the folder and install:
```bash
sudo apt install ./Zettlr-2.3.0-amd64.deb
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

### gbar
gbar uses a modified `.bashrc` and `.bash_aliases`, so make sure to link to those instead of the "default" ones:

```bash
cd $HOME
ln -s git/configs/._gbar_bashrc .bashrc
ln -s git/configs/._gbar_bash_aliases .bash_aliases
```

### Sophia
In a similar fashion to gbar, Sophia uses modified `.bashrc` and `.bash_aliases`:

```bash
cd $HOME
ln -s git/configs/._sophia_bashrc .bashrc
ln -s git/configs/._sophia_bash_aliases .bash_aliases
```

## Printer
The printer server at Risø Campus is `\\ait-pprintri02.win.dtu.dk`. To setup a particular printer, simply use the built-in GUI, as demonstrated in the picture:

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

## Miscellaneous
Kubuntu has a weird quirk where changing displays (e.g. when docking) can make the `plasma-org.kde.plasma.desktop-appletsrc` file go bad, resulting in the loss of the bottom toolbar. This file is found in `~/.config/`, and a backup is kept in this repo. In case of display or GUI weirdness, replace the file on your system with the file from this repo:
```bash
cp -f ~/git/configs/.config/plasma-org.kde.plasma.desktop-appletsrc ~/.config/plasma-org.kde.plasma.desktop-appletsrc
```
