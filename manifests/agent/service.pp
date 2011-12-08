class zabbix::agent::service {
    
	service { "zabbix-agent":
		ensure		=> running,
		name		=> "$zabbix::params::agent_service_name",
		hasstatus	=> true,
		hasrestart	=> true,
		require		=> Class["zabbix::agent::config"],
	 }
}