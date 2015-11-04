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
brew upgrade --all

# Install homebrew-cask, so we can use it manage installing binary/GUI apps
brew install caskroom/cask/brew-cask

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

# Install more recent versions of some OS X tools.
brew install homebrew/dupes/grep
brew install homebrew/dupes/openssh
brew install homebrew/dupes/screen

brew install ack
brew install git
brew install git-lfs
brew install glances
brew install hub
brew install lua
brew install lynx
brew install nvm
brew install rbenv
brew install ruby-build
brew install the_silver_searcher
brew install tree

# Setup rbenv
git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
sudo gem install bundler # TODO(riley): Do this w/o sudo

# Setup virtualenv
sudo easy_install --quiet pip
sudo pip install -q virtualenv

# Set up luarocks
echo 'rocks_servers = { "http://rocks.moonscript.org" }' >> /usr/local/etc/luarocks52/config-5.2.lua

# Install some Python packages
sudo pip install Pygments

# Install node packages
mkdir ~/.nvm
mkdir ~/.npm-packages
curl -L https://www.npmjs.com/install.sh | sh
npm i -g babel-core bower forever grunt-cli gulp http-server node-inspector node-sass nodemon npm-check-updates uglify-js vtop yo

# Install mjolnir window manager and dependencies
brew cask install mjolnir
luarocks install mjolnir.alert
luarocks install mjolnir.application
luarocks install mjolnir.bg.grid
luarocks install mjolnir.hotkey

SUPERPATH=$(readlink -f -- "$0") # This script file
SUPERMAC=$(dirname "$SUPERPATH")

# Remap caps lock -> hyper key (ctrl+alt+cmd)
brew cask install karabiner
brew cask install seil
cp $SUPERMAC/configs/karabiner/private.xml ~/Library/Application\ Support/Karabiner
# Open seil, check "Change the caps lock key", set keycode to 110.
# Open karabiner, check "PC Application Key to Hyper".
# Also, while you're there hit the "Key Repeat" tab and set:
#   Delay until repeat = 200ms
#   Key repeat         = 30ms

# Fonts
brew tap caskroom/fonts
brew cask install font-roboto-mono
brew cask install font-source-code-pro

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
curl https://raw.githubusercontent.com/chriskempson/tomorrow-theme/master/iTerm2/Tomorrow%20Night%20Eighties.itermcolors -o $SUPERMAC/external/tomorrow_night_eighties.itermcolors
# terminal.app
curl https://raw.githubusercontent.com/chriskempson/tomorrow-theme/master/OS%20X%20Terminal/Tomorrow%20Night%20Eighties.terminal -o $SUPERMAC/external/tomorrow_night_eighties.terminal
# pygments and cat
curl https://raw.githubusercontent.com/MozMorris/tomorrow-pygments/master/styles/tomorrownighteighties.py -o $SUPERMAC/external/tomorrownighteighties.py

lolcat cowsay "Woo! You're done setup."

echo
echo "To set up terminal colors,"
echo " - From iTerm2 > Preferences > Profiles > Colors, select $SUPERMAC/external/tomorrow_night_eighties.itermcolors"
echo " - From terminal.app > Preferences > Profile, select $SUPERMAC/external/tomorrow_night_eighties.terminal"
echo " - Audit $SUPERMAC/external/tomorrownighteighties.py, then run:"
echo "   sudo cp $SUPERMAC/external/tomorrownighteighties.py $(python -c "import sys; import site; print [p for p in sys.path if p.endswith('site-packages')][-1] if hasattr(sys,'real_prefix') else site.getsitepackages();")/pygments/styles/"
echo
