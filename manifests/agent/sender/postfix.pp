class zabbix::agent::sender::postfix (
  $active                = true,
  $sender_data_file_path = '/tmp/zabbix_postfix_status.data') inherits zabbix::params {
  file { "${zabbix::params::config_other_scripts_dir}/send_postfix.sh":
    ensure  => $active ? {
      true    => present,
      default => absent
    },
    owner   => root,
    group   => zabbix,
    mode    => '0750',
    content => template('zabbix/v2.x/etc/zabbix/other-scripts/send_postfix.sh.erb'),
    require => File[$zabbix::params::config_other_scripts_dir]
  } ->
  cron { 'zabbix_sender_postfix':
    ensure  => $active ? {
      true    => present,
      default => absent
    },
    command => "sudo ${zabbix::params::config_other_scripts_dir}/send_postfix.sh > /dev/null",
    user    => zabbix,
    target  => zabbix,
    minute  => '*/5',
    hour    => '*'
  }
}
