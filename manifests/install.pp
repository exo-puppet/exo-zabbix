class zabbix::install {
	package { "zabbix-agent":
		name	=> "$zabbix::params::package_name",
		ensure	=> "present",
	}
}