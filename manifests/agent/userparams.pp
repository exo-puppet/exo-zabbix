define zabbix::agent::userparams () {
  file { $name:
    ensure  => file,
    path    => "${zabbix::params::config_user_param_dir}/${name}",
    owner   => root,
    group   => zabbix,
    mode    => '0640',
    content => template("zabbix/v${zabbix::params::zabbix_version}/etc/zabbix/zabbix_agentd.d/${name}.erb"),
    require => File[$zabbix::params::config_user_param_dir],
    notify  => Class['zabbix::agent::service'],
  }
}
