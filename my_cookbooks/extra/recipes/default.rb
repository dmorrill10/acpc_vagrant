%w(dos2unix encfs octave gnuplot).map do |lib|
  package "#{lib}"
end

# Desktops
%w(ubuntu-gnome-desktop xfce4 i3 dkms).map do |lib|
  package "#{lib}"
end
