class zabbix::params {
  case $::operatingsystem {
    /(Ubuntu)/ : {
      $config_dir                  = '/etc/zabbix'
      $config_user_param_dir       = "${config_dir}/zabbix_agentd.d"
      $run_dir                     = '/var/run/zabbix'

      $zabbix_user                 = 'zabbix'

      # zabbix agent part
      $agent_service_name          = 'zabbix-agent'
      $agent_config_file           = "${config_dir}/zabbix_agentd.conf"
      $agent_config_template       = 'zabbix-agentd.conf.debian.erb'
      $agent_package_name          = 'zabbix-agent'
      $agent_log_dir               = '/var/log/zabbix-agent'
      $agent_unsafe_userparameters = $zabbix::agent_unsafe_userparameters ? {
        true    => '1',
        default => '0'
      }

      case $::lsbdistrelease {
        /(10.04)/ : {
          $zabbix_version       = '2.0'
        }
        /(10.10)/ : {
          $zabbix_version       = '1.8'
          $agent_initd_template = 'zabbix-agent.init.d-ubuntu_10.04.erb'
        }
        /(11.04|11.10)/ : {
          $zabbix_version       = '1.8'
          $agent_initd_template = 'zabbix-agent.init.d-ubuntu_11.04.erb'
        }
        /(12.04)/       : {
          $zabbix_version       = '2.2'

          ############################
          # zabbix server part
          ############################
          $server_service_name                = 'zabbix-server'
          $server_config_file                 = "${config_dir}/zabbix_server.conf"
          $server_config_template             = 'zabbix-server.conf.debian.erb'
          $server_package_name                = 'zabbix-server-mysql'
          $server_log_dir                     = '/var/log/zabbix-server'
          $server_install_mysql_tables_script = '/usr/share/zabbix-server-mysql/schema.sql'
          $server_install_mysql_data_script   = '/usr/share/zabbix-server-mysql/data.sql'
          $server_install_mysql_images_script = '/usr/share/zabbix-server-mysql/images.sql'

          ############################
          # zabbix frontend part
          ############################
          $frontend_package_name              = 'zabbix-frontend-php'
          $frontend_config_dir                = "${config_dir}/web"
          $frontend_apache_config_file        = "${config_dir}/apache.conf"
          $frontend_config_file               = "${frontend_config_dir}/zabbix.conf.php"
          $frontend_config_template           = 'zabbix.conf.php.erb'
        }
        default         : {
          fail("The ${module_name} module is not supported on ${::operatingsystem} ${::lsbdistrelease}")
        }
      }
    }
    default    : {
      fail("The ${module_name} module is not supported on ${::operatingsystem}")
    }
  }
}
