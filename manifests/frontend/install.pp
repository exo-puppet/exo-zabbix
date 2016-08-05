class zabbix::frontend::install {
  #########################################
  # Install Zabbix Agent package
  #########################################
  file { 'zabbix-frontend-php.preseed':
    ensure  => 'present',
    path    => '/var/local/preseed/zabbix-frontend-php.preseed',
    mode    => 600,
    backup  => false,
    content => template("zabbix/v${zabbix::params::zabbix_version}/zabbix-frontend-php.preseed.erb"),
    require => File['/var/local/preseed'],
  }

  ensure_packages ( 'zabbix-frontend', {
    'name'         => $zabbix::params::frontend_package_name,
    'responsefile' => '/var/local/preseed/zabbix-frontend-php.preseed',
    'require'      => [Apt::Source['zabbix'],Class['apt::update'],File['zabbix-frontend-php.preseed'],Service['zabbix-server']],
    'notify'       => Class['zabbix::frontend::config']
  } )
}
