class zabbix::agent::install {
    
	package { "zabbix-agent":
		name	=> "$zabbix::params::agent_package_name",
		ensure	=> "present",
        require   => [ Exec ["repo-update"], ],
	}

}