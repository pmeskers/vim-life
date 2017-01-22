# exit on error
set -e

# double-check
read -r -p "This will blow away any existing ~/.vim and ~/.vimrc. Are you sure? (y/n) " response
if [[ "$response" =~ ^([nN])+$ ]]; then
  printf "alright bye"
  exit
fi

# take out the trash
rm -rf ~/.vim
rm -f ~/.vimrc

# install vim-plug
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# link our vim configurations
cd `dirname $0`
ln -s `pwd`/vimrc ~/.vimrc
ln -s `pwd`/init ~/.vim/init

# create a file for local settings
touch ~/.vimrc.local

# run vim and install our plugins
vim -c ":PlugInstall" -c ":qa!"

# copy our local starting template
read -r -p "Create a ~/.vimrc.local configuration from template? (y/n) " response
if [[ "$response" =~ ^([yY])+$ ]]; then
  cp `pwd`/vimrc.local.template ~/.vimrc.local
fi

# change iTerm colorscheme
printf "\n\nnote: if using the nord-vim colorscheme, iTerm accompaniment recommended!"
printf "\nnord-iterm2: https://raw.githubusercontent.com/arcticicestudio/nord-iterm2/master/src/xml/Nord.itermcolors"


printf "\n\nDone!"

