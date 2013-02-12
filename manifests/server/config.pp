class zabbix::server::config {

	# TODO : check user zabbix and group zabbix

	# TODO : check directory /var/log/zabbix-server (zabbix:zabbix 766)
	# TODO : check directory /var/run/zabbix-server (zabbix:zabbix 766)

    file { $zabbix::params::server_config_file:
        ensure  => present,
        owner   => root,
        group   => root,
        mode    => 0640,
        content => template("zabbix/$zabbix::params::server_config_template"),
        backup  => ".${zabbix::params::server_config_template}-ORI",
        require => Class["zabbix::server::install"],
        notify  => Class["zabbix::server::service"],
  } ->
  file { "/etc/init.d/$zabbix::params::server_service_name":
        ensure => present,
        owner  => root,
        group  => root,
        mode   => 0655,
        content => template("zabbix/$zabbix::params::server_initd_template"),
        backup  => ".${zabbix::params::server_initd_template}-ORI",
        require => Class["zabbix::server::install"],
        notify  => Class["zabbix::server::service"],
    }
}
