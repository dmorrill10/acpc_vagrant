git "#{Chef::Config[:file_cache_path]}/opencv" do
  repository 'https://github.com/Itseez/opencv.git'
  revision '3.1.0'
end

git "#{Chef::Config[:file_cache_path]}/opencv_contrib" do
  repository 'https://github.com/Itseez/opencv_contrib.git'
  revision '3.1.0'
end

directory "#{Chef::Config[:file_cache_path]}/opencv/build"

PYTHON_INSTALL = File.join(Dir.home, '.anaconda')

# -D WITH_TBB=ON \
# -D WITH_V4L=ON \
# -D WITH_OPENGL=ON \

bash "make_opencv" do
  cwd "#{Chef::Config[:file_cache_path]}/opencv/build"
  code <<-EOH
cmake -D CMAKE_BUILD_TYPE=RELEASE \
      -D CMAKE_INSTALL_PREFIX=/usr/local \
      -D OPENCV_EXTRA_MODULES_PATH=#{Chef::Config[:file_cache_path]}/opencv_contrib/modules \
      -D PYTHON3_PACKAGES_PATH=#{PYTHON_INSTALL}/lib/python3.5/site-packages \
      -D PYTHON3_LIBRARY=#{PYTHON_INSTALL}/lib/libpython3.so \
      -D PYTHON3_INCLUDE_DIR=#{PYTHON_INSTALL}/include/python3.4m \
      -D BUILD_opencv_python3=ON \
      -D BUILD_NEW_PYTHON_SUPPORT=ON \
      -D INSTALL_C_EXAMPLES=OFF \
      -D INSTALL_PYTHON_EXAMPLES=OFF \
      -D BUILD_EXAMPLES=OFF ..
make -j2
EOH
end

bash 'install_opencv' do
  user "root"
  cwd "#{Chef::Config[:file_cache_path]}/opencv/build"
  code <<-EOH
make install
ldconfig
EOH
end
