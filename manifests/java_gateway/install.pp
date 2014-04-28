class zabbix::java_gateway::install {
  case $::operatingsystem {
    /(Ubuntu)/ : {
      case $::lsbdistrelease {
        /(12.04)/ : { # OK to install
        }
        default   : {
          fail("The ${module_name} module is not supported on ${::operatingsystem} ${::lsbdistrelease} for zabbix-server")
        }
      }
    }
    default    : {
      fail("The ${module_name} module is not supported on ${::operatingsystem} for zabbix-server")
    }
  }

  #########################################
  # Install Java gateway package
  #########################################
  repo::package { 'zabbix-java_gateway':
    pkg     => $zabbix::params::java_gateway_package_name,
    require => [Exec['repo-update']],
    notify  => [Class['zabbix::config']]
  } ->
  file { $zabbix::params::java_gateway_log_dir:
    ensure => directory,
    owner  => zabbix,
    group  => zabbix,
    mode   => 0644,
  }
}
