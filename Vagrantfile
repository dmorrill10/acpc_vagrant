# encoding: utf-8
# This file originally created at http://rove.io/81034967e7d436b5f9972910f9e39115

# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.box = "ubuntu/trusty64"
  config.ssh.forward_agent = true

  config.vm.network :forwarded_port, guest: 3000, host: 3000
  config.vm.network "private_network", ip: "10.10.10.10"

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

  config.vm.provision :chef_solo do |chef|
    chef.version = "11.18"
    chef.cookbooks_path = ["cookbooks"]
    chef.add_recipe :apt
    chef.add_recipe 'build-essential'
    chef.add_recipe :openssl
    chef.add_recipe :logrotate
    chef.add_recipe 'mongodb::default'
    chef.add_recipe 'sqlite'
    chef.add_recipe 'subversion'
    chef.add_recipe 'vim'
    chef.add_recipe 'nginx'
    chef.add_recipe 'git'
    chef.add_recipe 'nodejs'
    chef.add_recipe 'ruby_build'
    chef.add_recipe 'rbenv::system'
    chef.add_recipe 'rbenv::vagrant'
    chef.add_recipe 'redis'
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
      :nginx      => {
        :dir                => "/etc/nginx",
        :log_dir            => "/var/log/nginx",
        :binary             => "/usr/sbin/nginx",
        :user               => "www-data",
        :init_style         => "runit",
        :pid                => "/var/run/nginx.pid",
        :worker_connections => "1024"
      },
      :git        => {
        :prefix => "/usr/local"
      },
      :rbenv      => {
        :rubies => ["2.1.5"],
        :global => "2.1.5",
        :gems => {
          "2.1.5" => [
           { 'name' => 'bundler' },
           { 'name' => 'pry' },
           { 'name' => 'awesome_print' }
          ]
        }
      },
      :redis      => {
        :bind        => "127.0.0.1",
        :port        => "6379",
        :config_path => "/etc/redis/redis.conf",
        :daemonize   => "yes",
        :timeout     => "300",
        :loglevel    => "notice"
      }
    }
  end
  config.vm.provision :shell, path: 'grab_projects.sh', privileged: false
end
