directory File.join(Dir.home, ".program_files") do
  unless node['user_install_directory']['group'].nil?
    group node['user_install_directory']['group']
  end
  unless node['user_install_directory']['inherits'].nil?
    inherits node['user_install_directory']['inherits']
  end
  unless node['user_install_directory']['mode'].nil?
    mode node['user_install_directory']['mode']
  end
  unless node['user_install_directory']['notifies'].nil?
    notifies node['user_install_directory']['notifies']
  end
  unless node['user_install_directory']['owner'].nil?
    owner node['user_install_directory']['owner']
  end
  unless node['user_install_directory']['path'].nil?
    path node['user_install_directory']['path']
  end
  unless node['user_install_directory']['provider'].nil?
    provider node['user_install_directory']['provider']
  end
  unless node['user_install_directory']['recursive'].nil?
    recursive node['user_install_directory']['recursive']
  end
  unless node['user_install_directory']['rights'].nil?
    rights node['user_install_directory']['rights']
  end
  unless node['user_install_directory']['subscribes'].nil?
    subscribes node['user_install_directory']['subscribes']
  end
  unless node['user_install_directory']['action'].nil?
    action node['user_install_directory']['action']
  end
end
