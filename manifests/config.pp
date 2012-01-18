class zabbix::config {
    
	if ( $zabbix::agent == true ) {
	   include zabbix::agent::config
   }
	
    if ( $zabbix::server == true ) {
        include zabbix::server::config
    }

    if ( $zabbix::frontend == true ) {
        include zabbix::frontend::config
    }
}