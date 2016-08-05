class zabbix::install inherits zabbix::params {
  ################################################
  # WARNING : install the server before the agent
  ################################################
  case $::operatingsystem {
    /(Ubuntu)/ : {

      ################################################
      # Ensure the Config directory is exists
      ################################################
      file{$zabbix::params::config_dir:
        ensure  => directory,
        owner => root,
        group => root,
        mode  => '0644',
      }

      ################################################
      # Ensure the Run directory is exists
      ################################################

## DISABLED BECAUSE Zabbix user home = Zabbix Run directory => we can't declare 2x the same resource)
      if !defined(File[$zabbix::params::run_dir]) {
        file {$zabbix::params::run_dir:
          ensure  => directory,
          mode    => '0644',
          owner   => zabbix,
          group   => zabbix,
          require => Package['zabbix-agent']
        }
      }

      ################################################
      # Add Zabbix Debian Repo if v2.2
      ################################################
      case $zabbix::params::zabbix_version {
        /(2.0|2.2)/ : {
          apt::source { 'zabbix':
            location => "http://repo.zabbix.com/zabbix/${zabbix::params::zabbix_version}/ubuntu",
            key      => {
              'id'     => 'FBABD5FB20255ECAB22EE194D13D58E479EA5ED4',
              'server' => 'keyserver.ubuntu.com',
            },
            include  => {
              'src' => true,
              'deb' => true,
            },
          }
        }
      }

      ################################################
      # Zabbix Server install (if Ubuntu 12.04 only)
      ################################################
      if ($zabbix::server == true) {
        case $::lsbdistrelease {
          /(12.04)/ : { include zabbix::server::install }
          default   : { fail("The ${module_name} module (Server part) is not supported on ${::operatingsystem} ${::lsbdistrelease}") }
        }
      }

      ################################################
      # Zabbix Proxy install (if Ubuntu 12.04 only)
      ################################################
      if ($zabbix::proxy == true) {
        case $::lsbdistrelease {
          /(12.04|14.04)/ : { include zabbix::proxy::install }
          default   : { fail("The ${module_name} module (Proxy part) is not supported on ${::operatingsystem} ${::lsbdistrelease}") }
        }
      }

      ################################################
      # Zabbix Frontend install (if Ubuntu 12.04 only)
      ################################################
      if ($zabbix::frontend == true) {
        case $::lsbdistrelease {
          /(12.04)/ : { include zabbix::frontend::install }
          default   : { fail("The ${module_name} module (Frontend part) is not supported on ${::operatingsystem} ${::lsbdistrelease}") }
        }
      }

      ################################################
      # Zabbix Agent install
      ################################################
      if ($zabbix::agent == true) {
        case $::lsbdistrelease {
          /(10.04|10.10|11.04|11.10|12.04|14.04)/ : { include zabbix::agent::install }
          default   : { fail("The ${module_name} module (Agent part) is not supported on ${::operatingsystem} ${::lsbdistrelease}") }
        }
      }
    }
    ################################################
    # FAIL if not Ubuntu
    ################################################
    default    : {
      fail("The ${module_name} module is not supported on ${::operatingsystem}")
    }
  }
}
