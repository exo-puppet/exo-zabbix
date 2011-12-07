class zabbix::params {
    
	case $::operatingsystem {
		/(Ubuntu)/: {
		    # zabbix agent part
            $agent_service_name      = "zabbix-agent"
            $agent_config_file       = "/etc/zabbix/zabbix_agentd.conf"
            $agent_config_template   = "zabbix-agentd.conf.debian.erb"
            $agent_package_name      = "zabbix-agent"
            $agent_run_dir           = "/var/run/zabbix-agent"
            $agent_log_dir           = "/var/log/zabbix-agent"

            # zabbix server part
            $server_service_name    = "zabbix-server"
            $server_config_file     = "/etc/zabbix/zabbix_server.conf"
            $server_config_template = "zabbix-server.conf.debian.erb"
            $server_package_name    = "zabbix-server-mysql"
		}
		default: {
			fail ("The ${module_name} module is not supported on $::operatingsystem")
		}
	}
}