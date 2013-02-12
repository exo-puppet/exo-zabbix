class zabbix::agent::config {

    # TODO : check user zabbix and group zabbix

	file { $zabbix::params::agent_config_file:
        ensure => present,
        owner  => root,
        group  => root,
        mode   => 0644,
        content => template("zabbix/$zabbix::params::agent_config_template"),
        backup  => ".${zabbix::params::agent_config_template}-ORI",
        require => Class["zabbix::agent::install"],
        notify  => Class["zabbix::agent::service"],
	} ->
  file { "/etc/init.d/$zabbix::params::agent_service_name":
        ensure => present,
        owner  => root,
        group  => root,
        mode   => 0655,
        content => template("zabbix/$zabbix::params::agent_initd_template"),
        backup  => ".${zabbix::params::agent_initd_template}-ORI",
        require => Class["zabbix::agent::install"],
        notify  => Class["zabbix::agent::service"],
  }

}
