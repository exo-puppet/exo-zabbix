class zabbix::agent::sender::mysql ($active=true, $mysql_data_dir='/srv/mysql', $sender_data_file_path = '/tmp/zabbix_mysql_status.data') inherits zabbix::params {

  file { "${zabbix::params::config_other_scripts_dir}/send_mysql.sh":
    ensure  => $active ? {
      true    => present,
      default => absent
    },
    owner   => root,
    group   => zabbix,
    mode    => '0750',
    content => template('zabbix/v2.x/etc/zabbix/other-scripts/send_mysql.sh.erb'),
    require => File[$zabbix::params::config_other_scripts_dir]
  } ->
  cron { 'zabbix_sender_mysql':
    ensure  => $active ? {
      true    => present,
      default => absent
    },
    command => "${zabbix::params::config_other_scripts_dir}/send_mysql.sh > /dev/null",
    user    => zabbix,
    target  => zabbix,
    minute  => '*/15',
    hour    => '*'
  }
}
