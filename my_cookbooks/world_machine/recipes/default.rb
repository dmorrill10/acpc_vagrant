config_dir = File.join(Dir.home(node['world_machine']['user']), '.config')
wm_dir = File.join(config_dir, 'world-machine')

directory config_dir do
  user node['world_machine']['user']
  group node['world_machine']['user']
end

git wm_dir do
  user node['world_machine']['user']
  repository 'https://github.com/dmorrill10/world-machine.git'
  revision 'modular'
end

# rc="${ZDOTDIR:-$HOME}/.zshrc"

# cat >> $rc << END
# export CONFIG_HOME=$config
# export WORLD_MACHINE=\$CONFIG_HOME/world-machine
# source \$WORLD_MACHINE/terminal/environment.sh
# END
# source $rc

# echo -e "\n\nRunning world-machine scripts"

# mkdir -p $HOME/bin
# ./bin/link_bin
# ./git/setup_git.sh
# ./vim/setup_vim.sh
