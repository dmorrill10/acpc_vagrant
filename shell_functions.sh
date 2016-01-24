#!/bin/bash

# Copied from blog post by Joe Hirn
# https://www.devmynd.com/blog/2014-2-why-aren-t-you-using-vagrant#Cloning.repositories

needs_stash() {
  [[ $(git diff --shortstat 2> /dev/null | tail -n1) != "" ]] && echo "*"
}

git_grab(){
  repo=$1
  dest=$2
  DIR="$dest/`basename $repo .git`"
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
