
prezto_dir = File.join(Dir.home(node['prezto']['user']), '.zprezto')
prezto_source = 'https://github.com/dmorrill10/prezto.git'

git prezto_dir do
  user node['prezto']['user']
  repository prezto_source
  revision 'master'
  enable_submodules true
end

Dir.glob(File.join(Dir.home(node['prezto']['user']), '.zprezto/runcoms/z*')).each do |f|
  link File.join(Dir.home(node['prezto']['user']), ".#{File.basename(f)}") do
    to f
    link_type :symbolic
  end
end
