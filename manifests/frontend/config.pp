class zabbix::frontend::config {
  file { $zabbix::params::frontend_config_file:
    ensure  => present,
    owner   => root,
    group   => www-data,
    mode    => 0640,
    content => template("zabbix/${zabbix::params::frontend_config_template}"),
    backup  => ".${zabbix::params::frontend_config_template}-ORI",
    require => Class['zabbix::frontend::install'],
  }
}
