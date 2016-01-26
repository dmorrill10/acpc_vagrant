
prezto_dir = File.join(Dir.home(node['prezto']['user']), '.zprezto')
prezto_source = git@github.com:dmorrill10/prezto.git

git prezto_dir do
  repository prezto_source
  revision 'master'
  enable_submodules True
end

execute 'Link zsh files' do
  command <<-END
#!/usr/bin/env zsh
setopt EXTENDED_GLOB
for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
  rm "${ZDOTDIR:-$HOME}/.${rcfile:t}"
  ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
done
END
end
