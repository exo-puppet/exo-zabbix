class zabbix::agent::config {

  file { $zabbix::params::agent_config_file:
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => '0644',
    content => template("zabbix/v${zabbix::params::zabbix_version}/etc/zabbix/${zabbix::params::agent_config_template}"),
    require => Class['zabbix::agent::install'],
    notify  => Class['zabbix::agent::service'],
  } ->
  sudo::directive { 'zabbix':
    ensure  => present,
    content => template('zabbix/etc/sudoers.d/zabbix.erb'),
    require => Class['sudo'],
  }

  case $zabbix::params::zabbix_version {
    /(1.8)/     : {
      file { "/etc/init.d/${zabbix::params::agent_service_name}":
        ensure  => present,
        owner   => root,
        group   => root,
        mode    => '0655',
        content => template("zabbix/v${zabbix::params::zabbix_version}/etc/init.d/${zabbix::params::agent_initd_template}"),
        require => [Class['zabbix::agent::install'], File[$zabbix::params::agent_config_file]],
        notify  => Class['zabbix::agent::service'],
      }
    }
    /(2.0|2.2)/ : {
      # Remove all unmanaged user parameter files
      file { $zabbix::params::config_user_param_dir:
        ensure  => directory,
        recurse => true, # enable recursive directory management
        purge   => true, # purge all unmanaged junk
        force   => true, # also purge subdirs and links etc.
        owner   => root,
        group   => zabbix,
        mode    => '0640', # this mode will also apply to files from the source directory
        # puppet will automatically set +x for directories
        require => [Class['zabbix::agent::install'],File[$zabbix::params::config_dir]],
        notify  => Class['zabbix::agent::service'],
      } ->
      zabbix::agent::userparams { 'apache.conf': } ->
      zabbix::agent::userparams { 'disk.conf': } ->
      zabbix::agent::userparams { 'java.conf': } ->
      zabbix::agent::userparams { 'mysql.conf': } ->
      zabbix::agent::userparams { 'network.conf': } ->
      zabbix::agent::userparams { 'mailq.conf': } ->
      zabbix::agent::userparams { 'sslstatus.conf': } ->
      zabbix::agent::userparams { 'redis.conf': } ->
      zabbix::agent::userparams { 'docker.conf': } ->
      zabbix::agent::userparams { 'traefik.conf': }
      zabbix::agent::userparams { 'jenkins.conf': }
    }
  }

}
