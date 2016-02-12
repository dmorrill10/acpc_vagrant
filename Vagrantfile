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

  config.vm.network :forwarded_port, guest: 3000, host: 3000, auto_correct: true
  config.vm.network "private_network", ip: "10.10.10.10"

  config.vm.provider "virtualbox" do |v|
    v.customize ["modifyvm", :id, "--memory", "8168", "--ioapic", "on", "--cpus", 2]
    v.gui = false
  end

  config.vm.synced_folder Dir.home, "/host_home"

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

  config.vm.provision :shell, :inline => create_swap(10240, "/mnt/swapfile1")
  config.vm.provision :file, source: File.join(Dir.home, '.ssh', 'id_rsa'), destination: '/home/vagrant/.ssh/id_rsa'
  config.vm.provision :shell, :inline => 'chmod 600 /home/vagrant/.ssh/id_rsa'
  config.vm.provision :file, source: File.join(Dir.home, '.ssh', 'id_rsa.pub'), destination: '/home/vagrant/.ssh/id_rsa.pub'
  config.vm.provision :shell, :inline => 'chmod 644 /home/vagrant/.ssh/id_rsa.pub'
  config.vm.provision :file, source: File.join(Dir.home, '.ssh', 'known_hosts'), destination: '/home/vagrant/.ssh/known_hosts'
  config.vm.provision :shell, :inline => 'chmod 644 /home/vagrant/.ssh/known_hosts'

  ruby_version = '2.3.0'
  config.vm.provision :chef_solo do |chef|
    chef.binary_env = 'RUBY_CONFIGURE_OPTS=--disable-install-doc'
    chef.version = "12.6"
    chef.cookbooks_path = ["cookbooks", "my_cookbooks"]
    chef.add_recipe :apt
    chef.add_recipe 'build-essential'
    chef.add_recipe 'libxml2'
    chef.add_recipe :openssl
    chef.add_recipe :readline
    chef.add_recipe :basic_libraries
    chef.add_recipe :git
    chef.add_recipe :subversion
    chef.add_recipe :zsh
    chef.add_recipe :prezto
    chef.add_recipe :world_machine

    chef.add_recipe 'ruby'
    chef.add_recipe 'python'

    chef.add_recipe :logrotate
    chef.add_recipe 'mongodb::default'
    chef.add_recipe 'sqlite'
    chef.add_recipe 'nodejs'
    chef.add_recipe 'redisio'
    chef.add_recipe 'redisio::enable'

    chef.add_recipe 'vim'

    chef.add_recipe 'cabal'
    chef.add_recipe 'qt5'
    chef.add_recipe 'opencv'
    chef.add_recipe 'extra'

    chef.json = {
      :python => { user: 'vagrant' },
      :zsh => { user: 'vagrant' },
      :prezto => { user: 'vagrant' },
      :world_machine => { user: 'vagrant' },
      :opencv => { user: 'vagrant' },
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
      :ruby      => {
        :user_installs => [
          :user => 'vagrant',
          :gemrc => {
            verbose: true,
            gem: '--no-ri --no-rdoc',
            backtrace: false,
            bulk_threshold: 1000,
            benchmark: false
          },
          :rubies => [ruby_version],
          :global => ruby_version,
          :gems => {
            ruby_version => [
             { 'name' => 'bundler' },
             { 'name' => 'pry' },
             { 'name' => 'awesome_print' },
             { 'name' => 'rmate' }
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
end
