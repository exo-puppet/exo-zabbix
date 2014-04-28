class zabbix::config inherits zabbix::params {
  case $::operatingsystem {
    /(Ubuntu)/ : {
      ################################################
      # Zabbix Server install (if Ubuntu 12.04 only)
      ################################################
      if ($zabbix::server == true) {
        case $::lsbdistrelease {
          /(12.04)/ : { include zabbix::server::config }
          default   : { fail("The ${module_name} module (Server part) is not supported on ${::operatingsystem} ${::lsbdistrelease}") }
        }
      }

      ################################################
      # Zabbix Proxy install (if Ubuntu 12.04 only)
      ################################################
      if ($zabbix::proxy == true) {
        case $::lsbdistrelease {
          /(12.04)/ : { include zabbix::proxy::config }
          default   : { fail("The ${module_name} module (Proxy part) is not supported on ${::operatingsystem} ${::lsbdistrelease}") }
        }
      }

      ################################################
      # Zabbix Java Gateway install (if Ubuntu 12.04 only)
      ################################################
      if ($zabbix::java_gateway == true) {
        case $::lsbdistrelease {
          /(12.04)/ : { include zabbix::java_gateway::config }
          default   : { fail("The ${module_name} module (Java Gateway part) is not supported on ${::operatingsystem} ${::lsbdistrelease}") }
        }
      }

      ################################################
      # Zabbix Frontend install (if Ubuntu 12.04 only)
      ################################################
      if ($zabbix::frontend == true) {
        case $::lsbdistrelease {
          /(12.04)/ : { include zabbix::frontend::config }
          default   : { fail("The ${module_name} module (Frontend part) is not supported on ${::operatingsystem} ${::lsbdistrelease}") }
        }
      }

      ################################################
      # Zabbix Agent install
      ################################################
      if ($zabbix::agent == true) {
        case $::lsbdistrelease {
          /(10.04|10.10|11.04|11.10|12.04)/ : { include zabbix::agent::config }
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
