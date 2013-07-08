class zabbix::frontend::install {
  #########################################
  # Install Zabbix Agent package
  #########################################
  repo::package { 'zabbix-frontend':
    pkg     => $zabbix::params::frontend_package_name,
    preseed => template('zabbix/zabbix-frontend-php.preseed.erb'),
    require => [
      Exec['repo-update'],
      Service['zabbix-server']],
    notify  => Class['zabbix::frontend::config']
  } -> #########################################
       # Insert the Zabbix images data (workaround)
       #########################################
  file { '/usr/share/doc/zabbix-frontend-php/zabbix-table-images.sql.gz': source => 'puppet:///modules/zabbix/zabbix-table-images.sql.gz'
    } -> exec { 'zabbix-frontend-install-sql-images-data':
    path    => '/usr/bin:/usr/sbin:/bin',
    # Insert the zabbix images data
    command => "zcat /usr/share/doc/zabbix-frontend-php/zabbix-table-images.sql.gz | mysql ${zabbix::db_name}",
    # only insert initial data if the images table is empty
    onlyif  => "mysql ${zabbix::db_name} -NBe \"select count(*) from images\" | grep \"^0\"",
  }
}
