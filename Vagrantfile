# encoding: utf-8
# This file originally created at http://rove.io/81034967e7d436b5f9972910f9e39115

# -*- mode: ruby -*-
# vi: set ft=ruby :

# Thanks to colinsurprenant for this
# https://github.com/colinsurprenant/redstorm/blob/master/vagrant/Vagrantfile
#
# @param swap_size_mb [Integer] swap size in megabytes
# @param swap_file [String] full path for swap file, default is /swapfile1
# @return [String] the script text for shell inline provisioning
def create_swap(swap_size_mb, swap_file = "/swapfile1")
  <<-EOS
    if [ ! -f #{swap_file} ]; then
      echo "Creating #{swap_size_mb}mb swap file=#{swap_file}. This could take a while..."
      dd if=/dev/zero of=#{swap_file} bs=1024 count=#{swap_size_mb * 1024}
      mkswap #{swap_file}
      chmod 0600 #{swap_file}
      swapon #{swap_file}
      if ! grep -Fxq "#{swap_file} swap swap defaults 0 0" /etc/fstab
      then
        echo "#{swap_file} swap swap defaults 0 0" >> /etc/fstab
      fi
    fi
  EOS
end

Vagrant.configure("2") do |config|

  config.vm.box = "ubuntu/trusty64"
  config.ssh.forward_agent = true

  config.vm.network :forwarded_port, guest: 3000, host: 3000
  config.vm.network "private_network", ip: "10.10.10.10"

  config.vm.provider "virtualbox" do |v|
    v.customize ["modifyvm", :id, "--memory", "1024", "--ioapic", "on", "--cpus", 2]
  end

  provider = if ENV['VAGRANT_DEFAULT_PROVIDER'].nil? || ENV['VAGRANT_DEFAULT_PROVIDER'].empty?
    'virtualbox'
  else
    ENV['VAGRANT_DEFAULT_PROVIDER']
  end

  # Thanks to spkane for this workaround to a vagrant bug
  # https://github.com/mitchellh/vagrant/issues/5199
  #------------------------------------------------------
  # Require the Trigger plugin for Vagrant
  unless Vagrant.has_plugin?('vagrant-triggers')
    # Attempt to install ourself.
    # Bail out on failure so we don't get stuck in an infinite loop.
    system('vagrant plugin install vagrant-triggers') || exit!

    # Relaunch Vagrant so the new plugin(s) are detected.
    # Exit with the same status code.
    exit system('vagrant', *ARGV)
  end

  # Workaround for https://github.com/mitchellh/vagrant/issues/5199
  config.trigger.before [:reload, :up], stdout: true do
    SYNCED_FOLDER = ".vagrant/machines/default/#{provider}/synced_folders"
    info "Trying to delete folder #{SYNCED_FOLDER}"
    begin
      File.delete(SYNCED_FOLDER)
    rescue StandardError => e
      warn "Could not delete folder #{SYNCED_FOLDER}."
      warn e.inspect
    end
  end
  #------------------------------------------------------

  %w(autoconf bison build-essential libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm3 libgdbm-dev libffi-dev).each do |l|
    config.vm.provision :shell, :inline => "apt-get install -y #{l}"
  end
  ruby_version = '2.3.1'
  config.vm.provision :chef_solo do |chef|
    chef.binary_env = 'RUBY_CONFIGURE_OPTS=--disable-install-doc'
    chef.version = "11.18"
    chef.cookbooks_path = ["cookbooks", "my_cookbooks"]
    chef.data_bags_path = ["data_bags"]
    chef.add_recipe :apt
    chef.add_recipe 'build-essential'
    chef.add_recipe :openssl
    chef.add_recipe :readline
    chef.add_recipe :zsh
    chef.add_recipe :logrotate
    chef.add_recipe 'mongodb::default'
    chef.add_recipe 'sqlite'
    chef.add_recipe 'subversion'
    chef.add_recipe 'vim'
    chef.add_recipe 'git'
    chef.add_recipe 'nodejs'
    chef.add_recipe 'ruby_build'
    chef.add_recipe 'rbenv::user'
    chef.add_recipe 'rbenv::vagrant'
    chef.add_recipe 'redisio'
    chef.add_recipe 'redisio::enable'
    chef.add_recipe 'samba::default'
    chef.add_recipe 'samba::server'
    chef.add_recipe 'cabal'
    chef.add_recipe 'libxml2'
    chef.add_recipe 'libxml2::dev'

    chef.json = {
      :mongodb    => {
        :dbpath  => "/var/lib/mongodb",
        :logpath => "/var/log/mongodb",
        :port    => "27017"
      },
      :subversion => {
        :repo_dir    => "/srv/svn",
        :repo_name   => "repo",
        :server_name => "svn",
        :user        => "subversion",
        :password    => "subversion"
      },
      :vim        => {
        :extra_packages => [
          "vim-rails"
        ]
      },
      :git        => {
        :prefix => "/usr/local"
      },
      :rbenv      => {
        :user_installs => [
          :user => 'vagrant',
          :rubies => [ruby_version],
          :global => ruby_version,
          :gems => {
            ruby_version => [
             { 'name' => 'bundler' },
             { 'name' => 'pry' },
             { 'name' => 'awesome_print' }
            ]
          }
        ]
      },
      :redisio      => {
        :bind        => "127.0.0.1",
        :port        => "6379",
        :config_path => "/etc/redis/redis.conf",
        :daemonize   => "yes",
        :timeout     => "300",
        :loglevel    => "notice"
      }
    }
  end
  config.vm.provision :shell, :inline => create_swap(1024, "/mnt/swapfile1")
  config.vm.provision :file, source: File.join(Dir.home, '.ssh'), destination: '/home/vagrant/.ssh'
  config.vm.provision :shell, path: 'install_terminal_env.sh', privileged: false
  config.vm.provision :shell, path: 'install_python.sh', privileged: false
  config.vm.provision :shell, inline: 'sudo apt-get install encfs'
  config.vm.provision :shell, inline: 'sudo apt-get install zip cmake octave gnuplot'
end
