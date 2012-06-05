class zabbix::agent::install {
    #########################################
    # Install Zabbix Agent package
    #########################################
    repo::package { "zabbix-agent":
        pkg     => $zabbix::params::agent_package_name,
        preseed => template("zabbix/zabbix-agent.preseed.erb"),
        require => $zabbix::server ? {
            true    => [ Exec ["repo-update"], Service [ "zabbix-server" ] ],
            default => [ Exec ["repo-update"] ],
        }
    } -> 
	file { $zabbix::params::agent_run_dir:
        ensure => directory,
        owner  => zabbix,
        group  => zabbix,
        mode   => 0644,
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