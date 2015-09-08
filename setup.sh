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
# Don’t forget to add `$(brew --prefix coreutils)/libexec/gnubin` to `$PATH`.
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
brew install rbenv      # Note: don't forget to run:
brew install ruby-build # echo 'eval "$(rbenv init -)"' >> ~/.bash_profile
brew install the_silver_searcher
brew install tree

# Setup rbenv
git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile
echo 'eval "$(rbenv init -)"' >> ~/.bash_profile

# Setup virtualenv
sudo easy_install --quiet pip
sudo pip install -q virtualenv

# Install node packages
npm i -g babel bower grunt-cli gulp http-server node-sasss nodemon npm-check-updates uglify-js yo

# Very important
brew install cowsay
brew install fortune
brew install sl
gem install lolcat

# Remove outdated versions from the cellar.
brew cleanup
