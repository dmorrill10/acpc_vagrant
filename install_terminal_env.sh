#!/usr/bin/env zsh

my_dir=dirname "$(readlink -f "$0")"

source $my_dir/shell_functions.sh

git_grab git@github.com:dmorrill10/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
cd "${ZDOTDIR:-$HOME}/.zprezto" && git pull && git submodule update --init --recursive && cd -

setopt EXTENDED_GLOB
for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
  ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
done

mkdir -p $HOME/.config
git_grab git@github.com:dmorrill10/world-machine.git $HOME/.config/world-machine
cd $HOME/.config/world-machine
git checkout modular

cat >> "${ZDOTDIR:-$HOME}/.zsrch" << END
  export CONFIG_HOME=$HOME/.config
  export WORLD_MACHINE=$CONFIG_HOME/world-machine
  source $WORLD_MACHINE/terminal/environment.sh
END
source "${ZDOTDIR:-$HOME}/.zsrch"

mkdir -p $HOME/bin
./bin/link_bin
./git/setup_git.sh
./vim/setup_vim.sh
