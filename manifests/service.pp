class zabbix::service {
    
    if ( $zabbix::agent == true ) {
        include zabbix::agent::service
    }
	
	if ( $zabbix::server == true ) {
        include zabbix::server::service
	}
}