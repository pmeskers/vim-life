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

echo "==> Pulling latest changes..."
git pull

echo "==> Updating plugins..."
if command -v vim &> /dev/null; then
  vim -c ":PlugInstall" -c ":PlugUpdate" -c ":qa!"
else
  nvim -c ":PlugInstall" -c ":PlugUpdate" -c ":qa!"
fi

echo ""
echo "Done!"
