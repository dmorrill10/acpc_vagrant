anaconda_url = 'https://3230d63b5fc54e62148e-c95ac804525aac4b6dba79b00b39d1d3.ssl.cf1.rackcdn.com/Anaconda3-2.4.1-Linux-x86_64.sh'
anaconda = "Anaconda3-2.4.1-Linux-x86_64.sh"
install_location = Dir.home

remote_file "#{Chef::Config[:file_cache_path]}/#{anaconda}" do
  source anaconda_url
  mode '777'
end

directory install_location

install = File.join(install_location, '.anaconda')

bash "install_anaconda" do
  code "bash '#{Chef::Config[:file_cache_path]}/#{anaconda}'' -b -p #{install}"
end
