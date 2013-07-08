################################################################################
#
#   This module manages the Zabbix agent and server services.
#   Take note that this module only manage Zabbix for MySQL (not PostgreSQL yet)
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
# [+agent_unsafe_userparameters+]
#   (OPTIONAL) (default: true)
#
#   Allow all characters to be passed in arguments to user-defined parameters.
#   If false, the following char are not passed to the UserParameter : <pre> \ ' � ` * ? [ ] { } ~ $ ! & ; ( ) < > | # @ </pre>
#   Supported since Zabbix 1.8.2.
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
# [+db_host+]
#   (OPTIONAL) (default: localhost)
#
#   the host which contains the MySQL server to use.
#
# [+db_name+]
#   (OPTIONAL) (default: zabbix)
#
#   the name of the database to use.
#
# [+db_user+]
#   (OPTIONAL) (default: zabbix)
#
#   the user to connect to the zabbix database.
#
# [+db_password+]
#   (OPTIONAL) (default: wJPnl2ZEDCit)
#
#   the password of the user to connect to the zabbix database.
#
# [+frontend+]
#   (OPTIONAL) (default: false)
#
#   allow zabbix frontend on this node (true) or not (false)
#
# == Modules Dependencies
#
# [+repo+]
#   the +repo+ puppet module is needed to :
#
#   - refresh the repository before installing package (in zabbix::install)
#
# [+stdlib+]
#   the +stdlib+ puppet module is needed to :
#
#   - miscellaneous utilities functions
#
# [+mysql5+]
#   the +mysql5+ puppet module is needed to :
#
#   - create and manage the zabbix server database
#
# == Examples
#
# ===  Agent only usage
#
#   class { 'zabbix':
#       agent           => true,
#       server_hostname => 'zabbix.exemple.com',
#       server_port     => '10051',
#   }
#
# ===  Server only usage
#
#   class { 'zabbix':
#       agent           => false,
#       server          => true,
#       server_hostname => 'zabbix.exemple.com',
#       server_port     => '10051',
#   }
#
# ===  Agent and Server usage
#
#   class { 'zabbix':
#       agent           => true,
#       server          => true,
#       server_hostname => 'zabbix.exemple.com',
#       server_port     => '10051',
#   }
#
################################################################################
class zabbix (
  $agent       = true,
  $agent_port  = '10050',
  $agent_unsafe_userparameters = true,
  $server      = false,
  $server_hostname,
  $server_port = '10051',
  $db_host     = 'localhost',
  $db_name     = 'zabbix',
  $db_user     = 'zabbix',
  $db_password = 'zabbix',
  $frontend    = false) {
  # TODO : add the ability to configure mysql sock usage (in zabbix-server.conf.erb) when we have $mysql5::params::sock_path
  # available

  include repo
  include stdlib
  include zabbix::params, zabbix::install, zabbix::config, zabbix::service
}
