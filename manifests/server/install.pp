class zabbix::server::install {
    
    package { "zabbix-server":
        name    => "$zabbix::params::server_package_name",
        ensure  => "present",
        require   => [ Exec ["repo-update"], ],
    }
}