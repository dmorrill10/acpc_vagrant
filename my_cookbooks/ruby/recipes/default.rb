
require 'yaml'

node['ruby']['user_installs'].each do |user_install|
  gemrc_data = user_install['gemrc']
  user = user_install['user']
  user_home = Dir.home(user)

  gemrc_file = File.join(user_home, '.gemrc')

  file gemrc_file do
    content gemrc_data.to_hash.to_yaml
    owner user
    group user
    action :create_if_missing
  end

  rbenv_dir = File.join(user_home, '.rbenv')
  rbenv_repo = 'https://github.com/sstephenson/rbenv.git'

  git rbenv_dir do
    user user
    repository rbenv_repo
  end

  plugins_dir = File.join(rbenv_dir, 'plugins')
  directory plugins_dir do
    user user
    group user
  end

  ruby_build_dir = File.join(plugins_dir, 'ruby-build')
  ruby_build_repo = 'https://github.com/sstephenson/ruby-build.git'

  git ruby_build_dir do
    user user
    repository ruby_build_repo
  end

  rbenv_command = File.join(rbenv_dir, 'bin', 'rbenv')

  user_install['rubies'].each do |ruby_to_install|
    execute "Install ruby #{ruby_to_install} for user #{user}" do
      command "#{rbenv_command} install #{ruby_to_install} && #{rbenv_command} rehash"
      user user
      environment ({'HOME' => user_home, 'USER' => user})
      not_if { File.exist?(File.join(rbenv_dir, 'versions', ruby_to_install)) }
    end
  end

  execute "Set global ruby version for user #{user}" do
    command "#{rbenv_command} global #{user_install['global']}"
    user user
    environment ({'HOME' => user_home, 'USER' => user})
  end

  user_install['gems'].each do |ruby, gem_list|
    gem_list.each do |g|
      execute "Install #{g['name']} gem for ruby #{ruby} for user #{user}" do
        command <<-END
        export PATH="#{File.join(rbenv_dir, 'bin')}:$PATH"
        eval "$(rbenv init -)"
        rbenv shell #{ruby}
        gem install #{g['name']}
      END
        user user
        environment ({'HOME' => user_home, 'USER' => user})
      end
    end
  end
end
