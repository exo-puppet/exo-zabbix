class zabbix::proxy::service {
  service { 'zabbix-proxy':
    ensure     => running,
    name       => $zabbix::params::proxy_service_name,
    hasstatus  => true,
    hasrestart => true,
    require    => Class['zabbix::proxy::config'],
  }
}
