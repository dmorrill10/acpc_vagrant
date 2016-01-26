#!/usr/bin/env bash

anaconda_url='https://3230d63b5fc54e62148e-c95ac804525aac4b6dba79b00b39d1d3.ssl.cf1.rackcdn.com/Anaconda3-2.4.1-Linux-x86_64.sh'
anaconda="Anaconda3-2.4.1-Linux-x86_64.sh"
install_location="$HOME/.program_files"

cd $install_location

install_anaconda() {
  chmod +x $anaconda

  echo -e "\n\nRunning Anaconda installer."

  ./$anaconda -b -p $install_location/anaconda

  echo -e "\n\nAdding Anaconda to PATH"

  cat >> $HOME/.zshrc << END
# For anaconda
PATH=$install_location/anaconda/bin:\$PATH
END
  cat >> $HOME/.bashrc << END
# For anaconda
PATH=$install_location/anaconda/bin:\$PATH
END
}

if ![ -s $anaconda ]
then
  echo -e "\n\nDownloading Anaconda installer. This may take more than a few minutes."
  wget -q -o /dev/null - $anaconda_url
fi

install_anaconda
