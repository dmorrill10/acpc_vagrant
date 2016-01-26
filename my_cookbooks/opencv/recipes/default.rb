%w(pkg-config libjpeg8-dev libtiff4-dev libjasper-dev libpng12-dev libavcodec-dev libavformat-dev libswscale-dev libv4l-dev libgtk2.0-dev libatlas-base-dev gfortran).map do |lib|
  package "#{lib}"
end

PROJECT_DIRECTORY = "#{Chef::Config[:file_cache_path]}/opencv"

git "#{PROJECT_DIRECTORY}" do
  repository 'https://github.com/Itseez/opencv.git'
  revision '3.1.0'
end

directory "#{PROJECT_DIRECTORY}/build"

PYTHON = File.join(Dir.home(node['opencv']['user']), '.anaconda/bin/python')
NUMPY = File.join(Dir.home(node['opencv']['user']), '.anaconda/lib/python3.5/site-packages/numpy/core/include')
PYTHON_LIB = File.join(Dir.home(node['opencv']['user']), '.anaconda/lib')

bash "Create opencv Makefile" do
  cwd "#{PROJECT_DIRECTORY}/build"
  code <<-EOH
cmake \
-D ENABLE_SSE3=OFF \
-D BUILD_TIFF=ON \
-D BUILD_opencv_java=OFF \
-D WITH_CUDA=OFF \
-D ENABLE_AVX=OFF \
-D WITH_OPENGL=ON \
-D WITH_OPENCL=ON \
-D WITH_IPP=ON \
-D WITH_TBB=ON \
-D WITH_EIGEN=ON \
-D WITH_V4L=ON \
-D BUILD_TESTS=OFF \
-D BUILD_PERF_TESTS=OFF \
-D CMAKE_BUILD_TYPE=RELEASE \
-D CMAKE_INSTALL_PREFIX=$(#{PYTHON} -c "import sys; print(sys.prefix)") \
-D PYTHON3_EXECUTABLE=$(which #{PYTHON}) \
-D PYTHON3_INCLUDE_DIR=$(#{PYTHON} -c "from distutils.sysconfig import get_python_inc; print(get_python_inc())") \
-D PYTHON3_LIBRARIES=#{PYTHON_LIB} \
-D PYTHON3_PACKAGES_PATH=$(#{PYTHON} -c "from distutils.sysconfig import get_python_lib; print(get_python_lib())") \
-D PYTHON3_NUMPY_INCLUDE_DIRS=#{NUMPY} \
-D WITH_QT=ON \
-D INSTALL_C_EXAMPLES=OFF \
-D INSTALL_PYTHON_EXAMPLES=OFF \
-D BUILD_EXAMPLES=OFF \
-D BUILD_opencv_python3=ON ..
EOH
  not_if { File.exist?("#{PROJECT_DIRECTORY}/build/Makefile") }
end

bash 'Make opencv' do
  cwd "#{PROJECT_DIRECTORY}/build"
  code 'make -j2'
end

bash 'Install opencv' do
  user "root"
  cwd "#{PROJECT_DIRECTORY}/build"
  code <<-EOH
make install
ldconfig
EOH
end
