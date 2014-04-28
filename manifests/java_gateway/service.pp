class zabbix::java_gateway::service {
  service { 'zabbix-java-gateway':
    ensure     => $zabbix::java_gateway ? {
      true    => running,
      default => stopped
    },
    name       => $zabbix::params::java_gateway_service_name,
    hasstatus  => true,
    hasrestart => true,
    require    => Class['zabbix::java_gateway::config'],
  }
}
