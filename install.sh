# exit on error
set -e

# check dependencies
if ! command -v rg &> /dev/null; then
  echo "error: ripgrep (rg) is required but not installed."
  echo "  brew install ripgrep"
  exit 1
fi

# sanity check directory
if [[ $(pwd) != *vim-life ]]
then
  echo 'hey, you gotta run this from the vim-life directory. sorry.'
  exit
fi

# double-check
read -r -p "This will blow away any existing ~/.vim, ~/.vimrc, and ~/.config/nvim. Are you sure? (y/n) " response
if [[ "$response" =~ ^([nN])+$ ]]; then
  printf "alright bye"
  exit
fi

# take out the trash
rm -rf ~/.vim
rm -f ~/.vimrc
rm -f ~/.vimrc.local
rm -rf ~/.config/nvim

# create swap file directory
mkdir -p ~/.vim-tmp

# install vim-plug for vim
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
# and again for nvim
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# link vim configuration
ln -s $(pwd)/vimrc ~/.vimrc
ln -s $(pwd)/init ~/.vim/init

# link neovim configuration
mkdir -p ~/.config/nvim
ln -s $(pwd)/vimrc ~/.config/nvim/init.vim
ln -s $(pwd)/init ~/.config/nvim/init

# create a file for local settings
touch ~/.vimrc.local

# run vim and install our plugins
vim -c ":PlugInstall" -c ":qa!"

# copy our local starting template
cp $(pwd)/vimrc.local.template ~/.vimrc.local

# change iTerm colorscheme
printf "\n\nnote: if using the oceanic-next colorscheme, iTerm accompaniment recommended!"
printf "\noceanic-next-iterm2: https://github.com/mhartington/oceanic-next"

printf "\n\nDone!"
