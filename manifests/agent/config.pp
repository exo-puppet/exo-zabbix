class zabbix::agent::config {
    
    # TODO : check user zabbix and group zabbix
    
    # TODO : check directory /var/log/zabbix-agent (zabbix:zabbix 766)
    # TODO : check directory /var/run/zabbix-agent (zabbix:zabbix 766)

	file { $zabbix::params::agent_config_file:
        ensure => present,
        owner  => root,
        group  => root,
        mode   => 0644,
        content => template("zabbix/$zabbix::params::agent_config_template"),
        backup  => ".${zabbix::params::agent_config_template}-ORI",
        require => Class["zabbix::agent::install"],
        notify  => Class["zabbix::agent::service"],
	}

}