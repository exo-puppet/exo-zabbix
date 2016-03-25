class zabbix::agent::sender::elasticsearch ($active=true, $sender_data_file_path = '/tmp/zabbix_elasticsearch_status.data') inherits zabbix::params {
  ensure_packages('jq')

  file { "${zabbix::params::config_other_scripts_dir}/send_elasticsearch.sh":
    ensure  => $active ? {
      true    => present,
      default => absent
    },
    owner   => root,
    group   => zabbix,
    mode    => '0750',
    content => template('zabbix/v2.x/etc/zabbix/other-scripts/send_elasticsearch.sh.erb'),
    require => File[$zabbix::params::config_other_scripts_dir]
  } ->
  cron { 'zabbix_sender_elasticsearch':
    ensure  => $active ? {
      true    => present,
      default => absent
    },
    command => "${zabbix::params::config_other_scripts_dir}/send_elasticsearch.sh > /dev/null",
    user    => zabbix,
    target  => zabbix,
    minute  => '*',
    hour    => '*'
  }
}
