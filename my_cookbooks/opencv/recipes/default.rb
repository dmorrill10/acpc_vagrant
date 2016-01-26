git "#{Chef::Config[:file_cache_path]}/opencv" do
  repository https://github.com/Itseez/opencv.git
  revision 3.1.0
end

git "#{Chef::Config[:file_cache_path]}/opencv_contrib" do
  repository https://github.com/Itseez/opencv_contrib.git
  revision 3.1.0
end

directory "#{Chef::Config[:file_cache_path]}/opencv/build"

script "install_opencv" do
  user "root"
  cwd "#{Chef::Config[:file_cache_path]}/opencv/build"
  code <<-EOH
cmake -D CMAKE_BUILD_TYPE=RELEASE \
  -D CMAKE_INSTALL_PREFIX=/usr/local \
  -D INSTALL_C_EXAMPLES=OFF \
  -D INSTALL_PYTHON_EXAMPLES=OFF \
  -D OPENCV_EXTRA_MODULES_PATH=#{Chef::Config[:file_cache_path]}/opencv_contrib/modules \
  -D BUILD_EXAMPLES=OFF ..
make -j2
make install
ldconfig
EOH
end
