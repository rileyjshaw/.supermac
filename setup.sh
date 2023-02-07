#!/usr/bin/env bash
# Setup script for a new Mac; should only have to run this once.
#
# Taken almost entirely from:
# https://github.com/mathiasbynens/dotfiles/blob/master/brew.sh

# Ask for the administrator password upfront.
sudo -v

# Keep-alive: update existing `sudo` time stamp until the script has finished.
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Prevent the startup sound.
sudo nvram SystemAudioVolume=" "

# Avoid creation of .DS_Store and AppleDouble files.
# on network volumes.
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
# on USB volumes.
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Install homebrew.
if ! brew --help >/dev/null 2>&1; then
		/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
fi

# Make sure we’re using the latest Homebrew.
brew update

# Upgrade any already-installed formulae.
brew upgrade

mkdir ~/code

###
# Install command-line tools using Homebrew.
#####
# Install GNU core utilities (those that come with OS X are outdated).
brew install coreutils
sudo ln -s /usr/local/bin/gsha256sum /usr/local/bin/sha256sum

# Install GNU `find`, `locate`, `updatedb`, and `xargs`, `g`-prefixed.
brew install findutils
# Install GNU `sed`, also `g`-prefixed.
brew install gnu-sed
# Install Bash 5.
brew install bash
# Install some other useful utilities.
brew install rename
# Add the new shell to the list of allowed shells.
sudo bash -c 'echo /opt/homebrew/bin/bash >> /etc/shells'
# Change to the new shell (restart required before this will work).
chsh -s /opt/homebrew/bin/bash

brew install ack
brew install bash-completion@2
brew install gh
brew install git
brew install git-lfs
brew install gist
brew install glances
brew install gnupg
brew install hub
brew install imagemagick
brew install jq
brew install lua
brew install luarocks
brew install lynx
brew install ngrok/ngrok/ngrok
brew install nvm
brew install pandoc
brew install parallel
brew install postgresql
brew install pyenv
brew install shellcheck
brew install svn
brew install the_silver_searcher
brew install tmux
brew install tree
brew install vim
brew install wget
brew install woff2
brew install youtube-dl

brew services start postgresql

brew tap bramstein/webfonttools
brew install sfnt2woff

# Install ffmpeg with H.264, HEVC, and AV1 support.
brew tap homebrew-ffmpeg/ffmpeg
brew options homebrew-ffmpeg/ffmpeg/ffmpeg
brew install homebrew-ffmpeg/ffmpeg/ffmpeg --with-fdk-aac --with-rav1e --HEAD

brew tap heroku/brew && brew install heroku

# Install tpm for tmux.
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Install Vundle for Vim.
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

# Install image_optim deps.
brew install advancecomp gifsicle jhead jpegoptim jpeg optipng pngcrush pngquant jonof/kenutils/pngout

# Configure git.
git config --global user.email rileyjshaw@gmail.com
git config --global user.name "Riley Shaw"
git config --global core.editor vim
git config --global pull.rebase true
git lfs install
curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash -o ~/.git-completion.bash
gh auth login
gh config set editor vim

# Install some cask apps.
brew tap homebrew/cask-versions
brew install --cask \
  anki \
  arduino \
  audacity \
  bartender \
  bettertouchtool \
  blackhole-2ch \ # For routing audio between apps.
  blender \
  calibre \
  chruby \
  cyberduck \
  dbeaver-community \
  fig \
  google-chrome \
  homebrew/cask-versions/firefox-developer-edition \
  imageoptim \
  istat-menus \
  iterm2 \
  karabiner-elements \
  keka \
  keybase \
  kicad \
  lastpass \
  mjolnir \
  postman \
  ruby-install \
  sdformatter \
  signal \
  slack \
  spotify \
  steam \
  sunvox \
  syncthing \
  touchdesigner \
  transmission \
  vcv-rack \
  visual-studio-code \
  vlc \
  wireshark \
  zulip \
  zoom \
  ;

# Install QMK CLI and QMK Toolbox.
brew install qmk/qmk/qmk
brew tap homebrew/cask-drivers
brew install --cask qmk-toolbox

brew install imageoptim-cli

# Install a working Ruby version.
# NOTE: This will become outdated.
ruby-install 3.1.3
gem install bundler

# Set up pyenv and install some Python packages.
pyenv install 3.10.0
pyenv global 3.10.0
pip install Pygments

# Install node packages.
mkdir ~/.nvm
export NVM_DIR=~/.nvm
source $(brew --prefix nvm)/nvm.sh
mkdir ~/.nvm
nvm install --lts
nvm alias default lts/*
nvm use default
npm i -g http-server npm-check-updates yarn glyphhanger tldr
brew uninstall node --ignore-dependencies
mkdir /usr/local/Cellar/node
ln -s ~/.nvm/versions/node/$(nvm current)/ /usr/local/Cellar/node
brew link --overwrite node
brew pin node

# Install mjolnir window manager and dependencies.
luarocks install mjolnir.alert
luarocks install mjolnir.application
luarocks install mjolnir.bg.grid
luarocks install mjolnir.hotkey
luarocks install mjolnir.fnutils
luarocks install mjolnir.geometry
luarocks install mjolnir.keycodes
luarocks install mjolnir.screen

SUPERPATH=$(readlink -f -- "$0") # This script file.
SUPERMAC=$(dirname "$SUPERPATH")

# Remap caps lock -> hyper key, etc.
cp $SUPERMAC/configs/karabiner-elements/karabiner.json ~/.config/karabiner/

# Fonts.
brew tap homebrew/cask-fonts
brew install --cask \
  font-fira-code \
  font-hack-nerd-font \
  font-inconsolata \
  font-roboto-mono \
  font-source-code-pro \
  ;

# Very important.
brew install cowsay
brew install fortune
brew install lolcat
brew install sl

# Remove outdated versions from the cellar.
brew cleanup

[[ -d $SUPERMAC/external ]] || mkdir $SUPERMAC/external

# Theme the planet with Nord.
# iterm2
curl https://raw.githubusercontent.com/arcticicestudio/nord-iterm2/develop/src/xml/Nord.itermcolors -o $SUPERMAC/external/Nord.itermcolors
# terminal.app
curl https://raw.githubusercontent.com/arcticicestudio/nord-terminal-app/develop/src/xml/Nord.terminal -o $SUPERMAC/external/Nord.terminal
# pygments and cat
curl https://raw.githubusercontent.com/lewisacidic/nord-pygments/master/nord_pygments.py -o $SUPERMAC/external/Nord.py

# Set up gister.
cd ~
mkdir -p .local
mkdir -p code/gists
git clone https://github.com/weakish/gister.git
cd gister
echo 'PREFIX = ~/.local' > config.mk
make install
echo Gister is installed, run \"gister init\" and \"gister sync\" to finish setup.

cowsay | echo "Woo! You're done setup. Now run ./bootstrap.sh" | lolcat

echo
echo "To set up terminal colors,"
echo " - From iTerm2 > Preferences > Profiles > Colors, select $SUPERMAC/external/Nord.itermcolors"
echo " - From terminal.app > Preferences > Profile, select $SUPERMAC/external/Nord.terminal"
echo " - Audit $SUPERMAC/external/Nord.py, then run:"
echo "   sudo cp $SUPERMAC/external/Nord.py $(brew --prefix)/lib/python3.7/site-packages/pygments/styles"
echo
