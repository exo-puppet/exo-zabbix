################################################################################
#
#   This module manages the Zabbix agent and server services.
#
#   Tested platforms:
#    - Ubuntu 11.10 Oneiric
#    - Ubuntu 11.04 Natty
#    - Ubuntu 10.04 Lucid
#
# == Parameters
#
# [+agent+]
#   (OPTIONAL) (default: true) 
#   
#   allow zabbix agent on this node (true) or not (false)
#
# [+agent_port+]
#   (OPTIONAL) (default: 10050) 
#   
#   the port used by the zabbix agent to listen for active check
#
# [+server+]
#   (OPTIONAL) (default: false) 
#   
#   allow zabbix server on this node (true) or not (false)
#
# [+server_hostname+]
#   (MANDATORY) (default: ) 
#   
#   the full hostname of the zabbix server
#
# [+server_port+]
#   (OPTIONAL) (default: 10051) 
#   
#   the port used by the zabbix server to listen for agent connexions
#
# == Modules Dependencies
#
# [+repo+]
#   the +repo+ puppet module is needed to :
#   
#   - refresh the repository before installing package (in zabbix::install)
#
# == Examples
#
# ===  Agent only usage
#
#   class { "zabbix":
#       agent           => true,
#       server_hostname => "zabbix.exemple.com",
#       server_port     => "10051",
#   }
#
# ===  Server only usage
#
#   class { "zabbix":
#       agent           => false,
#       server          => true,
#       server_hostname => "zabbix.exemple.com",
#       server_port     => "10051",
#   }
#
# ===  Agent and Server usage
#
#   class { "zabbix":
#       agent           => true,
#       server          => true,
#       server_hostname => "zabbix.exemple.com",
#       server_port     => "10051",
#   }
#
################################################################################
class zabbix (  $agent = true,                          $agent_port = "10050",
                $server = false,    $server_hostname,   $server_port = "10051"
) {
    include repo
	include zabbix::params, zabbix::install, zabbix::config, zabbix::service
}