#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE}")";

git pull;

function doIt() {
	rsync --exclude ".git/" --exclude ".DS_Store" --exclude "bootstrap.sh" \
		--exclude "README.md" --exclude "LICENSE.md" --exclude "setup.sh" \
		--exclude "configs" --exclude ".gitignore" --exclude ".editorconfig" \
		--exclude "external" \
		-avh --no-perms . ~;

	mkdir -p ~/.config/karabiner
	cp configs/karabiner-elements/karabiner.json ~/.config/karabiner
	source ~/.bash_profile;
}

if [ "$1" == "--force" -o "$1" == "-f" ]; then
	doIt;
else
	read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1;
	echo "";
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		doIt;
	fi;
fi;
unset doIt;

# tmux
if "test ! -d ~/.tmux/plugins/tpm" \
   "run 'git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm && tmux new \"~/.tmux/plugins/tpm/bin/install_plugins\"'"

# vim
vim +PluginInstall +qall
