class zabbix::params {
	case $::operatingsystem {
		/(Ubuntu|Debian)/: {
			$service_name		= "zabbix-agent"
			$config_file		= "/etc/zabbix/zabbix_agentd.conf"
			$config_template	= "zabbix-agentd.conf.debian.erb"
			$package_name		= "zabbix-agent"
		}
		default: {
			fail ("The ${module_name} module is not supported on $::operatingsystem")
		}
	}
}