class zabbix::install {
    
    ################################################
    # WARNING : install the server before the agent
    ################################################
    
    # Zabbix Server install
    if ( $zabbix::server == true ) {
        include zabbix::server::install
    }

    # Zabbix Frontend install
    if ( $zabbix::frontend == true ) {
        include zabbix::frontend::install
    }

    # Zabbix Agent install
    if ( $zabbix::agent == true ) {
        include zabbix::agent::install
    }

}