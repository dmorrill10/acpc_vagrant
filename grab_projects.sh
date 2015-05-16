#!/bin/bash

# Copied from blog post by Joe Hirn
# https://www.devmynd.com/blog/2014-2-why-aren-t-you-using-vagrant#Cloning.repositories

needs_stash() {
  [[ $(git diff --shortstat 2> /dev/null | tail -n1) != "" ]] && echo "*"
}

root_dir=$1

git_grab(){
  DIR="$root_dir/repositories/`basename $1 .git`"
  if [ ! -d $DIR ]; then
  git clone $1 $DIR
  else
    pushd $DIR
    if needs_stash; then
      git stash
      git pull --quiet --rebase
      git stash pop
    else
      git pull --quiet --rebase
    fi
    popd
  fi
}

cd $root_dir
mkdir -p $root_dir/repositories

key_not_found=$(ssh-keygen -q -H -F github.com)
if [ -z "$key_not_found" ]; then
  github_key=$(ssh-keyscan -H github.com)
  ssh-keyscan -H github.com >> ~/.ssh/known_hosts
fi

ssh -q git@github.com
if [ "$?" -le "1" ]; then
  git_grab git@github.com:dmorrill10/acpc_poker_gui_client.git
  git_grab git@github.com:dmorrill10/acpc_dealer.git
  git_grab git@github.com:dmorrill10/acpc_poker_types.git
  git_grab git@github.com:dmorrill10/acpc_poker_basic_proxy.git
  git_grab git@github.com:dmorrill10/acpc_poker_player_proxy.git
else
  echo "Unable to grab repositories from Github through ssh forwarding."
  echo "Either load an ssh key registered with Github to your system's ssh key "
  echo "agent and re-provision ('vagrant provision'), or download the desired "
  echo "repositories manually inside the shared repositories directory."
fi
