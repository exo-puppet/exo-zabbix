class zabbix::server::install {

    #########################################
    # Install Zabbix Server package
    #########################################
    repo::package { "zabbix-server":
        pkg     => $zabbix::params::server_package_name,
        preseed => template("zabbix/zabbix-server-mysql.preseed.erb"),
        require => [ Exec [ "repo-update" ], Class [ "Mysql::Params" ] ],
        notify  => [ Mysql_grant [ "zabbix" ], Class [ "zabbix::config" ] ]
#        notify  => [ Class [ "zabbix::config" ] ]
    } -> 
	file { $zabbix::params::server_run_dir:
        ensure => directory,
        owner  => zabbix,
        group  => zabbix,
        mode   => 0644,
    } ->
	file { $zabbix::params::server_log_dir:
        ensure => directory,
        owner  => zabbix,
        group  => zabbix,
        mode   => 0644,
    } ->

    #########################################
    # Configure / Check Zabbix MySQL Database
    #########################################
    mysql_database { "zabbix":
        name    => $zabbix::db_name,
        ensure  => present,
        require => [ Service [ "mysql" ], Repo::Package [ "zabbix-server" ], Class [ "Mysql::Params" ] ],
        notify  => [ Mysql_user [ "zabbix" ], Class [ "zabbix::config" ] ],
    } ->

    mysql_user{ "zabbix":
        name            => "${zabbix::db_user}@localhost",
        password_hash   => mysql_password("zabbix"),
        require         => [ Mysql_database [ "zabbix" ], Class [ "Mysql::Params" ] ],
        notify          => [ Mysql_grant [ "zabbix" ], Class [ "zabbix::config" ] ],
    } ->

    mysql_grant { "zabbix":
        name        => "${zabbix::db_user}@%/zabbix",
        privileges  => "all",
        require     => Mysql_user [ "zabbix" ],
        notify      => Class [ "zabbix::config" ]
    } ->
    #########################################
    # Create the Zabbix tables
    #########################################
    exec { "zabbix-server-install-sql-create-tables":
        path        => "/usr/bin:/usr/sbin:/bin",
        # Create the zabbix tables
        command     => "mysql ${zabbix::db_name} < ${zabbix::params::server_install_mysql_tables_script}",
        # only create the zabbix tables if the table screens doesn't exists
        unless      => "mysql ${zabbix::db_name} -NBe \"select * from screens\"",
        timeout     => 0,
#        refreshonly => true,
        notify      => [ Class [ "zabbix::config"], Service["zabbix-server" ] ],
    } ->
    #########################################
    # Insert the Zabbix initial data
    #########################################
    exec { "zabbix-server-install-sql-first-data":
        path        => "/usr/bin:/usr/sbin:/bin",
        # Create the zabbix tables
        command     => "mysql ${zabbix::db_name} < ${zabbix::params::server_install_mysql_data_script}",
        # only insert initial data if Zabbix user doesn't exists
        unless      => "mysql ${zabbix::db_name} -NBe \"select * from users\" | grep Zabbix",
        timeout     => 0,
#        refreshonly => true,
        notify      => [ Class [ "zabbix::config"], Service["zabbix-server" ] ],
    }

}
