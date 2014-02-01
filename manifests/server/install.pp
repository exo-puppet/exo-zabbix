class zabbix::server::install {
  case $::operatingsystem {
    /(Ubuntu)/ : {
      case $::lsbdistrelease {
        /(12.04)/ : { # OK to install
           }
        default   : { fail("The ${module_name} module is not supported on ${::operatingsystem} ${::lsbdistrelease} for zabbix-server") }
      }
    }
    default    : {
      fail("The ${module_name} module is not supported on ${::operatingsystem} for zabbix-server")
    }
  }

  #########################################
  # Install Zabbix Server package
  #########################################
  repo::package { 'zabbix-server':
    pkg     => $zabbix::params::server_package_name,
    preseed => template("zabbix/v${zabbix::params::zabbix_version}/zabbix-server-mysql.preseed.erb"),
    require => [Exec['repo-update'], Class['Mysql::Params'], File[$zabbix::params::run_dir]],
    notify  => [Mysql_grant['zabbix'], Class['zabbix::config']]
  } ->
  file { $zabbix::params::server_log_dir:
    ensure => directory,
    owner  => zabbix,
    group  => zabbix,
    mode   => 0644,
  } ->
  #########################################
  # Configure / Check Zabbix MySQL Database
  #########################################
  mysql_database { 'zabbix':
    ensure  => present,
    name    => $zabbix::db_name,
    require => [Service['mysql'], Repo::Package['zabbix-server'], Class['Mysql::Params']],
    notify  => [Mysql_user['zabbix'], Class['zabbix::config']],
  } -> mysql_user { 'zabbix':
    name          => "${zabbix::db_user}@localhost",
    password_hash => mysql_password('zabbix'),
    require       => [Mysql_database['zabbix'], Class['Mysql::Params']],
    notify        => [Mysql_grant['zabbix'], Class['zabbix::config']],
  } -> mysql_grant { 'zabbix':
    name       => "${zabbix::db_user}@%/zabbix",
    privileges => 'all',
    require    => Mysql_user['zabbix'],
    notify     => Class['zabbix::config']
  } ->
  #########################################
  # Create the Zabbix tables
  #########################################
  exec { 'zabbix-server-install-sql-create-tables':
    path    => '/usr/bin:/usr/sbin:/bin',
    # Create the zabbix tables
    command => "mysql ${zabbix::db_name} < ${zabbix::params::server_install_mysql_tables_script}",
    # only create the zabbix tables if the table screens doesn't exists
    unless  => "mysql ${zabbix::db_name} -NBe \"select * from screens\"",
    timeout => 0,
    environment => ["HOME=${::root_home}"],
    #        refreshonly => true,
    notify  => [Class['zabbix::config'],Service['zabbix-server']],
  } ->
  #########################################
  # Insert the Zabbix images data
  #########################################
  exec { 'zabbix-frontend-install-sql-images-data':
    path    => '/usr/bin:/usr/sbin:/bin',
    # Insert the zabbix images data
    command => "mysql ${zabbix::db_name} < ${zabbix::params::server_install_mysql_images_script}",
    # only insert initial data if the images table is empty
    onlyif  => "mysql ${zabbix::db_name} -NBe \"select count(*) from images\" | grep \"^0\"",
    timeout => 0,
    environment => ["HOME=${::root_home}"],
    #        refreshonly => true,
    notify  => [Class['zabbix::config'],Service['zabbix-server']],
  } ->
  #########################################
  # Insert the Zabbix initial data
  #########################################
  exec { 'zabbix-server-install-sql-first-data':
    path    => '/usr/bin:/usr/sbin:/bin',
    # Create the zabbix tables
    command => "mysql ${zabbix::db_name} < ${zabbix::params::server_install_mysql_data_script}",
    # only insert initial data if Zabbix user doesn't exists
    unless  => "mysql ${zabbix::db_name} -NBe \"select * from users\" | grep Zabbix",
    timeout => 0,
    environment => ["HOME=${::root_home}"],
    #        refreshonly => true,
    notify  => [Class['zabbix::config'],Service['zabbix-server']],
  }

}
