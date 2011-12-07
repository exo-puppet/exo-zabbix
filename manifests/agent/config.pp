class zabbix::agent::config {
    
    # TODO : check user zabbix and group zabbix
    
    # TODO : check directory /var/log/zabbix-agent (zabbix:zabbix 766)
    # TODO : check directory /var/run/zabbix-agent (zabbix:zabbix 766)

	file { $zabbix::params::agent_config_file:
		ensure => file,
		owner  => root,
		group  => root,
		mode   => 0644,
		content => template("zabbix/$zabbix::params::agent_config_template"),
		require => Class["zabbix::install"],
		notify => Class["zabbix::service"],
	}
	
	
}