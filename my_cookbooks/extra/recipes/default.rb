%w(dos2unix encfs octave gnuplot texlive-full biber bibutils haskell-platform).map do |lib|
  package "#{lib}"
end

include_recipe 'cabal'

cabal_update 'pandoc' do
  user 'vagrant'
end
cabal_install 'pandoc' do
  user 'vagrant'
  force_reinstalls true
end

# Desktops
%w(ubuntu-gnome-desktop xfce4 i3 dkms).map do |lib|
  package "#{lib}"
end
