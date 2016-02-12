anaconda_url = 'https://3230d63b5fc54e62148e-c95ac804525aac4b6dba79b00b39d1d3.ssl.cf1.rackcdn.com/Anaconda3-2.4.1-Linux-x86_64.sh'
anaconda = "Anaconda3-2.4.1-Linux-x86_64.sh"

user = node['python']['user']
install_location = Dir.home user

anaconda_install_script = "#{Chef::Config[:file_cache_path]}/#{anaconda}"

remote_file "Download Anaconda install script" do
  path anaconda_install_script
  source anaconda_url
  mode '777'
  not_if { File.exists?(anaconda_install_script) }
end

install = File.join(install_location, '.anaconda')

execute "Install Anaconda" do
  cwd Chef::Config[:file_cache_path]
  command <<-EOH
    #{anaconda_install_script} -b -p #{install}
    cat >> $HOME/.zshrc << END
    # For anaconda
    PATH=#{install}/bin:\$PATH
    END
    cat >> $HOME/.bashrc << END
    # For anaconda
    PATH=#{install}/bin:\$PATH
    END
  EOH
  user user
  environment ({'HOME' => install_location, 'USER' => user})
  not_if { File.exists?(install) }
end

pypy_versions = {'pypy' => 'pypy-4.0.1-linux64', 'pypy3' => 'pypy3-2.4.0-linux64'}
pypy_versions.each do |name, version|
  pypy_url = "https://bitbucket.org/pypy/pypy/downloads/#{version}.tar.bz2"
  pypy_compressed = pypy_url.split('/').last

  pypy_install_location = File.join(Dir.home(user), ".#{name}")

  remote_file "Download #{name}" do
    path File.join(Chef::Config[:file_cache_path], pypy_compressed)
    source pypy_url
    mode '777'
    user user
    group user
    not_if { File.exists?(pypy_install_location) }
  end

  execute "Extract #{pypy_compressed}" do
    cwd Chef::Config[:file_cache_path]
    user user
    group user
    command "tar -jxf #{pypy_compressed} && mv #{version} #{pypy_install_location}"
    not_if { File.exists?(pypy_install_location) }
  end
end
