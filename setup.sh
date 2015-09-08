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
# Note: don’t forget to add `/usr/local/bin/bash` to `/etc/shells` before
# running `chsh`.
brew install bash
brew tap homebrew/versions
brew install bash-completion2

# Install `wget` with IRI support.
brew install wget --with-iri

# Install more recent versions of some OS X tools.
brew install homebrew/dupes/grep
brew install homebrew/dupes/openssh
brew install homebrew/dupes/screen
brew install homebrew/php/php55 --with-gmp

brew install ack
brew install git
brew install git-lfs
brew install glances
brew install lua
brew install lynx
brew install node
brew install rbenv
brew install ruby-build
brew install the_silver_searcher
brew install tree

# Setup rbenv
git clone https://github.com/sstephenson/rbenv.git ~/.rbenv

# Setup virtualenv
sudo easy_install --quiet pip
sudo pip install -q virtualenv

# Set up luarocks
echo 'rocks_servers = { "http://rocks.moonscript.org" }' >> /usr/local/etc/luarocks52/config-5.2.lua

# Install some Python packages
sudo pip install Pygments

# Install node packages
npm i -g babel bower grunt-cli gulp http-server node-sasss nodemon npm-check-updates uglify-js yo

# Install mjolnir window manager and dependencies
brew cask install mjolnir
luarocks install mjolnir.alert
luarocks install mjolnir.application
luarocks install mjolnir.bg.grid
luarocks install mjolnir.hotkey

# Fonts
brew tap caskroom/fonts
brew cask install font-source-code-pro

# Very important
brew install cowsay
brew install fortune
brew install sl
gem install lolcat

# Theme the planet with Tomorrow Night Eighties
# iterm2
curl https://raw.githubusercontent.com/chriskempson/tomorrow-theme/master/iTerm2/Tomorrow%20Night%20Eighties.itermcolors -o ./external/tomorrow_night_eighties.itermcolors
# terminal.app
curl https://raw.githubusercontent.com/chriskempson/tomorrow-theme/master/OS%20X%20Terminal/Tomorrow%20Night%20Eighties.terminal -o ./external/tomorrow_night_eighties.terminal
# pygments and cat
sudo curl https://raw.githubusercontent.com/MozMorris/tomorrow-pygments/master/styles/tomorrownighteighties.py -o /Library/Python/2.7/site-packages/pygments/styles/tomorrownighteighties.py

# Remove outdated versions from the cellar.
brew cleanup
