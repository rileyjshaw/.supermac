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
		/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
fi

# Make sure we’re using the latest Homebrew.
brew update

# Upgrade any already-installed formulae.
brew upgrade

mkdir ~/code

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
# Install some other useful utilities.
brew install rename
# Add the new shell to the list of allowed shells
sudo bash -c 'echo /usr/local/bin/bash >> /etc/shells'
# Change to the new shell (restart required before this will work)
chsh -s /usr/local/bin/bash

brew install ack
brew install bash-completion2
brew install git
brew install git-lfs
brew install glances
brew install gh
brew install hub
brew install imagemagick
brew install lua
brew install luarocks
brew install lynx
brew install nvm
brew install postgresql
brew install pyenv
brew install rbenv
brew install ruby-build
brew install shellcheck
brew install the_silver_searcher
brew install tmux
brew install tree
brew install vim
brew install wget

brew tap homebrew-ffmpeg/ffmpeg
brew install homebrew-ffmpeg/ffmpeg/ffmpeg --with-fdk-aac --HEAD

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
  bartender \
  bettertouchtool \
  calibre \
  cyberduck \
  dbeaver-community \
  dropbox \
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
  signal \
  spotify \
  sunvox \
  visual-studio-code \
  vlc \
  wireshark \
  ;

brew install imageoptim-cli

# Setup rbenv
rbenv init
gem install bundler

# Set up pyenv and install some Python packages
pyenv install 3.9.0
pyenv global 3.9.0
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
luarocks install mjolnir.alert
luarocks install mjolnir.application
luarocks install mjolnir.bg.grid
luarocks install mjolnir.hotkey

SUPERPATH=$(readlink -f -- "$0") # This script file
SUPERMAC=$(dirname "$SUPERPATH")

# Remap caps lock -> hyper key (ctrl+alt+cmd)
cp $SUPERMAC/configs/karabiner-elements/karabiner.json ~/.config/karabiner/

# Fonts
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

# Theme the planet with Tomorrow Night Eighties
# iterm2
curl https://raw.githubusercontent.com/arcticicestudio/nord-iterm2/develop/src/xml/Nord.itermcolors -o $SUPERMAC/external/Nord.itermcolors
# terminal.app
curl https://raw.githubusercontent.com/arcticicestudio/nord-terminal-app/develop/src/xml/Nord.terminal -o $SUPERMAC/external/Nord.terminal
# pygments and cat
curl https://raw.githubusercontent.com/lewisacidic/nord-pygments/master/nord_pygments.py -o $SUPERMAC/external/Nord.py

cowsay | lolcat "Woo! You're done setup. Now run ./bootstrap.sh"

echo
echo "To set up terminal colors,"
echo " - From iTerm2 > Preferences > Profiles > Colors, select $SUPERMAC/external/Nord.itermcolors"
echo " - From terminal.app > Preferences > Profile, select $SUPERMAC/external/Nord.terminal"
echo " - Audit $SUPERMAC/external/Nord.py, then run:"
echo "   sudo cp $SUPERMAC/external/Nord.py $(brew --prefix)/lib/python3.7/site-packages/pygments/styles"
echo
