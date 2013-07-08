class zabbix::server::service {
  service { 'zabbix-server':
    ensure     => running,
    name       => $zabbix::params::server_service_name,
    hasstatus  => true,
    hasrestart => true,
    require    => Class['zabbix::server::config'],
  }
}
