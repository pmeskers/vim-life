# exit on error
set -e

# sanity check directory
if [[ `pwd` != *vim-life ]]
then
  echo 'hey, you gotta run this from the vim-life directory. sorry.'
  exit
fi

# pull in the latest changes
git pull -r

# run vim and install our plugins
vim -c ":PlugInstall" -c ":qa!"
vim -c ":source ~/.vimrc" -c ":qa!"
