class zabbix::frontend::config {

  if !defined(File[$zabbix::params::frontend_config_dir]) {
    file { $zabbix::params::frontend_config_dir:
      ensure  => directory,
      owner   => root,
      group   => www-data,
      require => Class['zabbix::frontend::install'],
    }
  }

  file { $zabbix::params::frontend_config_file:
    ensure  => present,
    owner   => root,
    group   => www-data,
    mode    => 0640,
    content => template("zabbix/v${zabbix::params::zabbix_version}${zabbix::params::frontend_config_dir}/${zabbix::params::frontend_config_template}"),
    require => [File[$zabbix::params::frontend_config_dir],Class['zabbix::frontend::install']],
  } ->
  ###########################
  # Install an Apache VHost for Zabbix Frontend
  ###########################
  apache2::vhost { $zabbix::frontend_hostname:
      activated    => $zabbix::frontend ? {
        false => false,
        default => true
      },
      # alias for vagrant testing (we need a *.exoplatform.org due to ssl certificates)
      server_aliases    => [ 'monitoring-vagrant.exoplatform.org' ],
      ssl          => $zabbix::frontend_ssl,
      redirect2ssl => $zabbix::frontend_redirect2ssl,
      includes     => $zabbix::params::frontend_apache_config_file,
      require      => [Class['apache2'],Class['zabbix']],
    }
}
