#!/usr/bin/env zsh

my_dir=/vagrant

source $my_dir/shell_functions.sh

echo -e "\n\nDownloading prezto"

rm -rf "${ZDOTDIR:-$HOME}/.zprezto"
git_grab git@github.com:dmorrill10/prezto.git "${ZDOTDIR:-$HOME}"
mv "${ZDOTDIR:-$HOME}/prezto" "${ZDOTDIR:-$HOME}/.zprezto"
cd "${ZDOTDIR:-$HOME}/.zprezto" && git pull && git submodule update --init --recursive && cd -

setopt EXTENDED_GLOB
for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
  rm "${ZDOTDIR:-$HOME}/.${rcfile:t}"
  ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
done

config=$HOME/.config

mkdir -p $config

echo -e "\n\nDownloading world-machine"

rm -rf $config/world-machine
git_grab git@github.com:dmorrill10/world-machine.git $config
cd $config/world-machine
git checkout modular

rc="${ZDOTDIR:-$HOME}/.zshrc"

cat >> $rc << END
export CONFIG_HOME=$config
export WORLD_MACHINE=\$CONFIG_HOME/world-machine
source \$WORLD_MACHINE/terminal/environment.sh
END
source $rc

echo -e "\n\nRunning world-machine scripts"

mkdir -p $HOME/bin
./bin/link_bin
./git/setup_git.sh
./vim/setup_vim.sh
