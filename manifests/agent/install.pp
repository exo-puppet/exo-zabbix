class zabbix::agent::install {
  #########################################
  # Install Zabbix Agent package
  #########################################
  repo::package { "zabbix-agent":
      pkg     => $zabbix::params::agent_package_name,
      preseed => template("zabbix/zabbix-agent.preseed.erb"),
      require => $zabbix::server ? {
          true    => [ Exec ["repo-update"], Service [ "zabbix-server" ], File [ "${zabbix::params::run_dir}" ] ],
          default => [ Exec ["repo-update"], File [ "${zabbix::params::run_dir}" ] ],
      }
  } ->
  # enforce to remove old zabbix agent pid directory (for clean migration)
  # TODO you can now remove this File directive deletion because I think that all server are now updated
  file { "/var/run/${zabbix::params::agent_package_name}":
        ensure  => absent,
        force   => true,
  } ->
	file { $zabbix::params::agent_log_dir:
        ensure => directory,
        owner  => zabbix,
        group  => zabbix,
        mode   => 0644,
	}

    if ( $::mysql_exists == "true") {
        mysql_user{ "zabbix-agent":
            name            => "zabbix-agent@localhost",
            password_hash   => mysql_password("zabbix-agent!"),
            require         => [ Repo::Package [ "zabbix-agent" ], Class [ "Mysql::Install", "Mysql::Service" ] ],
        } ->
        mysql::userconfig { "mysql-user-zabbix-agent":
            username => "zabbix",
            mysql_username  => "zabbix-agent",
            mysql_password  => "zabbix-agent!",
        }
    }
}
