class zabbix::agent::sender::sslstatus ($active=true, $sender_data_file_path = '/tmp/zabbix_ssl_status.data') inherits zabbix::params {

  file { "${zabbix::params::config_other_scripts_dir}/_checkSSL.sh":
    ensure  => $active ? {
      true    => present,
      default => absent
    },
    owner   => root,
    group   => zabbix,
    mode    => '0750',
    content => template('zabbix/v2.x/etc/zabbix/other-scripts/_checkSSL.sh'),
    require => File[$zabbix::params::config_other_scripts_dir]
  } 
}
