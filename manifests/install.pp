class zabbix::install {
    
    # Zabbix Agent install
    if ( $zabbix::agent == true ) {
        include zabbix::agent::install
    }

    # Zabbix Server install
    if ( $zabbix::server == true ) {
        include zabbix::server::install
    }
}