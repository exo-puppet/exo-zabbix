class zabbix::server::config {
    
	# TODO : check user zabbix and group zabbix
	
	# TODO : check directory /var/log/zabbix-server (zabbix:zabbix 766)
	# TODO : check directory /var/run/zabbix-server (zabbix:zabbix 766)
	
    file { $zabbix::params::server_config_file:
        ensure => file,
        owner  => root,
        group  => root,
        mode   => 0644,
        content => template("zabbix/$zabbix::params::server_config_template"),
        require => Class["zabbix::server::install"],
        notify => Class["zabbix::server::service"],
    }
}