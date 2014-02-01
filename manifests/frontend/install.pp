class zabbix::frontend::install {
  #########################################
  # Install Zabbix Agent package
  #########################################
  repo::package { 'zabbix-frontend':
    pkg     => $zabbix::params::frontend_package_name,
    preseed => template("zabbix/v${zabbix::params::zabbix_version}/zabbix-frontend-php.preseed.erb"),
    require => [Exec['repo-update'],Service['zabbix-server']],
    notify  => Class['zabbix::frontend::config']
  }
}
