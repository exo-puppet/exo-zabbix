class zabbix::frontend::install {
    #########################################
    # Install Zabbix Agent package
    #########################################
    repo::package { "zabbix-frontend":
        pkg     => $zabbix::params::frontend_package_name,
        preseed => template("zabbix/zabbix-frontend-php.preseed.erb"),
        require => [ Exec ["repo-update"], Service [ "zabbix-server" ] ],
    }
}