class zabbix::service {
	service { "zabbix-agent":
		ensure		=> running,
		name		=> "$zabbix::params::service_name",
		hasstatus	=> true,
		hasrestart	=> true,
		require		=> Class["zabbix::config"],
	}
}