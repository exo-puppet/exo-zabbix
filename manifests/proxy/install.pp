class zabbix::proxy::install {
  case $::operatingsystem {
    /(Ubuntu)/ : {
      case $::lsbdistrelease {
        /(12.04|14.04)/ : {
            # OK to install
          }
        default   : { fail("The ${module_name} module is not supported on ${::operatingsystem} ${::lsbdistrelease} for zabbix-server") }
      }
    }
    default    : {
      fail("The ${module_name} module is not supported on ${::operatingsystem} for zabbix-server")
    }
  }

  #########################################
  # Install Zabbix Proxy package
  #########################################
  file { 'zabbix-proxy-mysql.preseed':
    ensure  => 'present',
    path    => '/var/local/preseed/zabbix-proxy-mysql.preseed',
    mode    => 600,
    backup  => false,
    content => template("zabbix/v${zabbix::params::zabbix_version}/zabbix-proxy-mysql.preseed.erb"),
    require => File['/var/local/preseed'],
  }

  ensure_packages ( 'zabbix-proxy', {
    'name'         => $zabbix::params::proxy_package_name,
    'responsefile' => '/var/local/preseed/zabbix-proxy-mysql.preseed',
    'require'      => [Apt::Source['zabbix'],Class['apt::update'],File['zabbix-proxy-mysql.preseed'],Class['Mysql::Params']],
    'notify'       => [Mysql_grant['zabbix'], Class['zabbix::config']]
  } )

  file { $zabbix::params::proxy_log_dir:
    ensure  => directory,
    owner   => zabbix,
    group   => zabbix,
    mode    => '0644',
    require => Package['zabbix-proxy']
  } ->
  #########################################
  # Configure / Check Zabbix MySQL Database
  #########################################
  mysql_database { 'zabbix':
    ensure  => present,
    name    => $zabbix::proxy_db_name,
    require => [Service['mysql'], Package['zabbix-proxy'], Class['Mysql::Params']],
    notify  => [Mysql_user['zabbix'], Class['zabbix::config']],
  } -> mysql_user { 'zabbix':
    name          => "${zabbix::db_user}@localhost",
    password_hash => mysql_password('zabbix'),
    require       => [Mysql_database['zabbix'], Class['Mysql::Params']],
    notify        => [Mysql_grant['zabbix'], Class['zabbix::config']],
  } -> mysql_grant { 'zabbix':
    name       => "${zabbix::db_user}@%/${zabbix::proxy_db_name}",
    privileges => 'all',
    require    => Mysql_user['zabbix'],
    notify     => Class['zabbix::config']
  } ->
  #########################################
  # Create the Zabbix tables
  #########################################
  exec { 'zabbix-proxy-install-sql-create-tables':
    path    => '/usr/bin:/usr/sbin:/bin',
    # Create the zabbix tables
    command => "mysql ${zabbix::proxy_db_name} < ${zabbix::params::proxy_install_mysql_tables_script}",
    # only create the zabbix tables if the table screens doesn't exists
    unless  => "mysql ${zabbix::proxy_db_name} -NBe \"select * from screens\"",
    timeout => 0,
    environment => ["HOME=${::root_home}"],
    #        refreshonly => true,
    notify  => [Class['zabbix::config'],Service['zabbix-proxy']],
  }

}
