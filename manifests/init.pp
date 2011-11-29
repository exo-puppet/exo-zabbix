class zabbix ($zabbix_server = "localhost", $zabbix_server_port = "10051") {
	include zabbix::params, zabbix::install, zabbix::config, zabbix::service
}