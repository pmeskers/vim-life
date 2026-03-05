#!/usr/bin/env bash
# exit on error
set -e

# run from script directory regardless of where it's called from
cd "$(dirname "$0")"

# check dependencies
if ! command -v rg &> /dev/null; then
  echo "error: ripgrep (rg) is required but not installed."
  echo "  brew install ripgrep"
  exit 1
fi

if ! command -v vim &> /dev/null && ! command -v nvim &> /dev/null; then
  echo "error: vim or nvim is required but neither is installed."
  exit 1
fi

# show what will change before asking for confirmation
echo "This will configure the following:"
echo "  ~/.vimrc                 -> symlink to $(pwd)/vimrc"
echo "  ~/.vim/init              -> symlink to $(pwd)/init"
echo "  ~/.config/nvim/init.vim  -> symlink to $(pwd)/vimrc"
echo "  ~/.config/nvim/init      -> symlink to $(pwd)/init"
echo "  ~/.vim-tmp/              -> created if not present"
if [ ! -f ~/.vimrc.local ]; then
  echo "  ~/.vimrc.local           -> created from template (first run)"
else
  echo "  ~/.vimrc.local           -> preserved (already exists)"
fi

# warn if nvim config exists and doesn't appear to be ours
SKIP_NVIM=false
if [ -d ~/.config/nvim ] && [ ! -L ~/.config/nvim/init.vim ]; then
  echo ""
  echo "warning: ~/.config/nvim exists and does not appear to be managed by vim-life."
  echo "  Neovim configuration will be skipped. Set it up manually if needed."
  SKIP_NVIM=true
fi

echo ""
read -r -p "Proceed? (y/n) " response
if [[ "$response" =~ ^([nN])+$ ]]; then
  echo "Aborted."
  exit
fi
echo ""

echo "==> Creating swap file directory..."
mkdir -p ~/.vim-tmp

echo "==> Installing vim-plug..."
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

echo "==> Linking vim configuration..."
ln -sf "$(pwd)/vimrc" ~/.vimrc
ln -sf "$(pwd)/init" ~/.vim/init

if [ "$SKIP_NVIM" = false ]; then
  echo "==> Linking neovim configuration..."
  mkdir -p ~/.config/nvim
  ln -sf "$(pwd)/vimrc" ~/.config/nvim/init.vim
  ln -sf "$(pwd)/init" ~/.config/nvim/init
fi

if [ ! -f ~/.vimrc.local ]; then
  echo "==> Creating ~/.vimrc.local from template..."
  cp "$(pwd)/vimrc.local.template" ~/.vimrc.local
else
  echo "==> Preserving existing ~/.vimrc.local"
fi

echo "==> Installing plugins..."
if command -v vim &> /dev/null; then
  vim -c "set nomore" -c ":PlugInstall" -c ":qa!"
else
  nvim -c "set nomore" -c ":PlugInstall" -c ":qa!"
fi

echo ""
echo "note: if using the nord colorscheme, an iTerm theme is available:"
echo "  https://raw.githubusercontent.com/arcticicestudio/nord-iterm2/master/src/xml/Nord.itermcolors"
echo ""
echo "Done!"
