#!/usr/bin/env bash
# Setup script for a new Mac; should only have to run this once.
#
# Taken almost entirely from:
# https://github.com/mathiasbynens/dotfiles/blob/master/brew.sh

# Ask for the administrator password upfront.
sudo -v

# Keep-alive: update existing `sudo` time stamp until the script has finished.
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Prevent the startup sound
sudo nvram SystemAudioVolume=" "

# Avoid creation of .DS_Store and AppleDouble files
# on network volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
# on USB volumes
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Install homebrew
if ! brew --help >/dev/null 2>&1; then
		ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Make sure we’re using the latest Homebrew.
brew update

# Upgrade any already-installed formulae.
brew upgrade

###
# Install command-line tools using Homebrew
#####
# Install GNU core utilities (those that come with OS X are outdated).
brew install coreutils
sudo ln -s /usr/local/bin/gsha256sum /usr/local/bin/sha256sum

# Install some other useful utilities like `sponge`.
brew install moreutils
# Install GNU `find`, `locate`, `updatedb`, and `xargs`, `g`-prefixed.
brew install findutils
# Install GNU `sed`, overwriting the built-in `sed`.
brew install gnu-sed --with-default-names
# Install Bash 4.
brew install bash
# Add the new shell to the list of allowed shells
sudo bash -c 'echo /usr/local/bin/bash >> /etc/shells'
# Change to the new shell (restart required before this will work)
chsh -s /usr/local/bin/bash

brew tap homebrew/versions
brew install bash-completion2

# Install `wget` with IRI support.
brew install wget --with-iri

brew install ack
brew install git
brew install git-lfs
brew install glances
brew install hub
brew install lua
brew install luarocks
brew install lynx
brew install nvm
brew install pyenv
brew install rbenv
brew install ruby-build
brew install the_silver_searcher
brew install tmux
brew install tree
brew install vim

# Install Vundle for Vim.
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

# Install image_optim deps.
brew install advancecomp gifsicle jhead jpegoptim jpeg optipng pngcrush pngquant jonof/kenutils/pngout

# Configure git.
git config --global user.email rileyjshaw@gmail.com
git config --global user.name "Riley Shaw"
git config --global core.editor vim
git lfs install
curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash -o ~/.git-completion.bash

# Install some cask apps.
brew cask install \
  iterm2 \
  keka \
  keybase \
	wireshark \
  visual-studio-code \
  ;

# Setup rbenv
sudo gem install bundler # TODO(riley): Do this w/o sudo

# Set up luarocks
echo 'rocks_servers = { "http://rocks.moonscript.org" }' >> /usr/local/etc/luarocks52/config-5.2.lua

# Set up pyenv and install some Python packages
pyenv install 3.7.4
pyenv global 3.7.4
pip install Pygments

# Install node packages
mkdir ~/.nvm
export NVM_DIR=~/.nvm
source $(brew --prefix nvm)/nvm.sh
nvm install node
nvm alias default node
nvm use default
npm i -g http-server npm-check-updates yarn
brew uninstall node --ignore-dependencies
mkdir /usr/local/Cellar/node
ln -s ~/.nvm/versions/node/$(nvm current)/ /usr/local/Cellar/node
brew link --overwrite node
brew pin node

# Install mjolnir window manager and dependencies
brew cask install mjolnir karabiner-elements
luarocks install mjolnir.alert
luarocks install mjolnir.application
luarocks install mjolnir.bg.grid
luarocks install mjolnir.hotkey

SUPERPATH=$(readlink -f -- "$0") # This script file
SUPERMAC=$(dirname "$SUPERPATH")

# Remap caps lock -> hyper key (ctrl+alt+cmd)
brew cask install karabiner-elements
cp $SUPERMAC/configs/karabiner-elements/karabiner.json ~/.config/karabiner/

# Fonts
brew tap homebrew/cask-fonts
brew cask install font-roboto-mono
brew cask install font-source-code-pro
brew cask install font-fira-code

# tmux
if "test ! -d ~/.tmux/plugins/tpm" \
   "run 'git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm && ~/.tmux/plugins/tpm/bin/install_plugins'"

# Very important
brew install cowsay
brew install fortune
brew install sl
gem install lolcat

# Remove outdated versions from the cellar.
brew cleanup

[[ -d $SUPERMAC/external ]] || mkdir $SUPERMAC/external

# Theme the planet with Tomorrow Night Eighties
# iterm2
curl https://raw.githubusercontent.com/arcticicestudio/nord-iterm2/develop/src/xml/Nord.itermcolors -o $SUPERMAC/external/Nord.itermcolors
# terminal.app
curl https://raw.githubusercontent.com/arcticicestudio/nord-terminal-app/develop/src/xml/Nord.terminal -o $SUPERMAC/external/Nord.terminal
# pygments and cat
curl https://raw.githubusercontent.com/lewisacidic/nord-pygments/master/nord_pygments.py -o $SUPERMAC/external/Nord.py

lolcat cowsay "Woo! You're done setup."

echo
echo "To set up terminal colors,"
echo " - From iTerm2 > Preferences > Profiles > Colors, select $SUPERMAC/external/Nord.itermcolors"
echo " - From terminal.app > Preferences > Profile, select $SUPERMAC/external/Nord.terminal"
echo " - Audit $SUPERMAC/external/Nord.py, then run:"
echo "   sudo cp $SUPERMAC/external/Nord.py $(brew --prefix)/lib/python3.7/site-packages/pygments/styles
echo
