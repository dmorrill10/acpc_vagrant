%w(dos2unix encfs octave gnuplot).map do |lib|
  package "#{lib}"
end

# Desktops
%w(ubuntu-gnome-desktop i3 virtualbox-guest-dkms virtualbox-guest-utils virtualbox-guest-x11).map do |lib|
  package "#{lib}"
end
