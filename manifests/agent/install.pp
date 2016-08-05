class zabbix::agent::install {
  #########################################
  # Install Zabbix Agent package
  #########################################
  file { 'zabbix-agent.preseed':
    ensure  => 'present',
    path    => '/var/local/preseed/zabbix-agent.preseed',
    mode    => 600,
    backup  => false,
    content => template("zabbix/v${zabbix::params::zabbix_version}/zabbix-agent.preseed.erb"),
    require => File['/var/local/preseed'],
  }

  if $zabbix::params::zabbix_version =~ /(2.0|2.2)/ {
    ensure_packages ( $zabbix::params::agent_package_name, {
      'responsefile'  => '/var/local/preseed/zabbix-agent.preseed',
      'require'       => $zabbix::server ? {
        true    => [Apt::Source['zabbix'],Class['apt::update'],File['zabbix-agent.preseed'], Service['zabbix-server']],
        default => [Apt::Source['zabbix'],Class['apt::update'],File['zabbix-agent.preseed']],
      },
    } )
  } else {
    # for old Ubuntu version without LTS like 11.04 (no binary repo provided by zabbix)
    ensure_packages ( $zabbix::params::agent_package_name, {
      'responsefile'  => '/var/local/preseed/zabbix-agent.preseed',
      'require'       => [Class['apt::update'],File['zabbix-agent.preseed']],
    } )
  }

  file { $zabbix::params::agent_log_dir:
    ensure => directory,
    owner  => zabbix,
    group  => zabbix,
    mode   => '0644',
    require => Package['zabbix-agent'],
  } ->
  # Add directory for other scripts
  file { $zabbix::params::config_other_scripts_dir:
    ensure  => directory,
    path    => $zabbix::params::config_other_scripts_dir,
    owner   => root,
    group   => zabbix,
    mode    => '0755',
    require => File[$zabbix::params::config_dir],
  }

  # If MySQL is present on the system, we create a zabbix mysql user to be able to monitor MySQL
  if (str2bool($::mysql_exists)) {
    mysql_user { 'zabbix-agent':
      name          => 'zabbix-agent@localhost',
      password_hash => mysql_password('zabbix-agent!'),
      require       => [Package['zabbix-agent'], Class['Mysql::Install', 'Mysql::Service']],
    } -> mysql::userconfig { 'mysql-user-zabbix-agent':
      username       => 'zabbix',
      mysql_username => 'zabbix-agent',
      mysql_password => 'zabbix-agent!',
    }
  }


}
