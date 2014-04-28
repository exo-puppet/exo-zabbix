class zabbix::java_gateway::config {
  file { $zabbix::params::java_gateway_config_file:
    ensure  => $zabbix::java_gateway ? {
      true    => present,
      default => absent
    },
    owner   => root,
    group   => root,
    mode    => 0640,
    content => template("zabbix/v${zabbix::params::zabbix_version}${zabbix::params::config_dir}/${zabbix::params::java_gateway_config_template}"),
    require => Class['zabbix::java_gateway::install'],
    notify  => Class['zabbix::java_gateway::service'],
  }
}
