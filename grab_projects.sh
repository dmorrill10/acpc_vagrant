#!/bin/bash

my_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source $my_dir/shell_functions.sh

root_dir=$1

cd $root_dir
mkdir -p $root_dir/repositories

key_not_found=$(ssh-keygen -q -H -F github.com)
if [ -z "$key_not_found" ]; then
  github_key=$(ssh-keyscan -H github.com)
  ssh-keyscan -H github.com >> ~/.ssh/known_hosts
fi

ssh -q git@github.com
if [ "$?" -le "1" ]; then
  git_grab git@github.com:dmorrill10/acpc_poker_gui_client.git $root_dir/repositories
  git_grab git@github.com:dmorrill10/acpc_dealer.git $root_dir/repositories
  git_grab git@github.com:dmorrill10/acpc_poker_types.git $root_dir/repositories
  git_grab git@github.com:dmorrill10/acpc_poker_basic_proxy.git $root_dir/repositories
  git_grab git@github.com:dmorrill10/acpc_poker_player_proxy.git $root_dir/repositories
else
  echo "Unable to grab repositories from Github through ssh forwarding."
  echo "Either load an ssh key registered with Github to your system's ssh key "
  echo "agent and re-provision ('vagrant provision'), or download the desired "
  echo "repositories manually inside the shared repositories directory."
fi
