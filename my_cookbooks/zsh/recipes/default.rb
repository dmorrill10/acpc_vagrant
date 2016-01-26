package 'zsh'
execute "Set zsh as default shell" do
  command "chsh -s $(which zsh) #{node['zsh']['user']}"
end
