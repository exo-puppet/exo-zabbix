define zabbix::agent::sender::elasticsearch_node (
  $active                 = true, 
  $sender_data_file_path  = '/tmp/zabbix_elasticsearch_node_status.data',
  $port                   = 9200, 
) {
  ensure_packages('jq')

  ensure_resource ( 'file', "${zabbix::params::config_other_scripts_dir}/send_elasticsearch_node.sh", {
    ensure  => $active ? {
      true    => present,
      default => absent
    },
    owner   => root,
    group   => zabbix,
    mode    => '0750',
    content => template('zabbix/v2.x/etc/zabbix/other-scripts/send_elasticsearch_node.sh.erb'),
    require => File[$zabbix::params::config_other_scripts_dir]
  })
  cron { "zabbix_sender_elasticsearch_node_${port}" :
    ensure  => $active ? {
      true    => present,
      default => absent
    },
    command => "${zabbix::params::config_other_scripts_dir}/send_elasticsearch_node.sh ${port} > /dev/null",
    user    => zabbix,
    target  => zabbix,
    minute  => '*',
    hour    => '*'
  }    
}
