class zabbix::server::install {

    #########################################
    # Install Zabbix Server package
    #########################################
    repo::package { "zabbix-server":
        pkg     => $zabbix::params::server_package_name,
        preseed => template("zabbix/zabbix-server-mysql.preseed.erb"),
        require => Exec [ "repo-update" ],
        notify  => [ Mysql_grant [ "zabbix" ], Class [ "zabbix::config" ] ]
    }

    #########################################
    # Configure / Check Zabbix MySQL Database
    #########################################
    mysql_database { "zabbix": 
        name    => $zabbix::db_name,
        ensure  => present,
        require => [ Service [ "mysql" ], Repo::Package [ "zabbix-server" ] ],
        notify  => [ Mysql_user [ "zabbix" ], Class [ "zabbix::config" ] ],
    }
     
    mysql_user{ "zabbix":
        name            => "${zabbix::db_user}@localhost",
        password_hash   => mysql_password("zabbix"),
        require         => Mysql_database [ "zabbix" ],
        notify          => [ Mysql_grant [ "zabbix" ], Class [ "zabbix::config" ] ],
    }
                
    mysql_grant { "zabbix": 
        name        => "${zabbix::db_user}@%/zabbix",
        privileges  => "all", 
        require     => Mysql_user [ "zabbix" ],
        notify      => Class [ "zabbix::config" ]
    }
    
}