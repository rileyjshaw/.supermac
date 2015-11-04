# HACK(rjs): Left in to appease khan-dotfiles, but redundant w/ . .bash_profile
# if [ -s ~/.bashrc.khan ]; then
#     source ~/.bashrc.khan
# fi

[ -n "$PS1" ] && source ~/.bash_profile;

export NVM_DIR="/Users/rileyjshaw/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
