class zabbix::proxy::config {
  file { $zabbix::params::proxy_config_file:
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => '0640',
    content => template("zabbix/v${zabbix::params::zabbix_version}${zabbix::params::config_dir}/${zabbix::params::proxy_config_template}"),
    require => Class['zabbix::proxy::install'],
    notify  => Class['zabbix::proxy::service'],
  }

}
