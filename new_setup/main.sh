#!/bin/bash

set -e

echo "Installing basic packages"
sudo bash basic_install.sh

echo "installing p10k"
bash p10k.sh

echo "setting .zshrc customizations"
cat my_zshrc >> ~/.zshrc

