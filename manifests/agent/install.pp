class zabbix::agent::install {
    #########################################
    # Install Zabbix Agent package
    #########################################
    repo::package { "zabbix-agent":
        pkg     => $zabbix::params::agent_package_name,
        preseed => template("zabbix/zabbix-agent.preseed.erb"),
        require => $zabbix::server ? {
            true    => [ Exec ["repo-update"], Service [ "zabbix-server" ] ],
            default => [ Exec ["repo-update"] ],
        }
    }
}