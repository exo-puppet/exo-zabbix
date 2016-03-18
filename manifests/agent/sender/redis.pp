class zabbix::agent::sender::redis ($active=true, $sender_data_file_path = '/tmp/zabbix_redis_status.data') inherits zabbix::params {

  file { "${zabbix::params::config_other_scripts_dir}/send_redis.sh":
    ensure  => $active ? {
      true    => present,
      default => absent
    },
    owner   => root,
    group   => zabbix,
    mode    => '0750',
    content => template('zabbix/v2.x/etc/zabbix/other-scripts/send_redis.sh.erb'),
    require => File[$zabbix::params::config_other_scripts_dir]
  } ->
  cron { 'zabbix_sender_redis':
    ensure  => $active ? {
      true    => present,
      default => absent
    },
    command => "${zabbix::params::config_other_scripts_dir}/send_redis.sh > /dev/null",
    user    => zabbix,
    target  => zabbix,
    minute  => '*',
    hour    => '*'
  }
}
