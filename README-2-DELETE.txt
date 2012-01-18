### conf.d/php-fcgid.conf
AddHandler fcgid-script .fcgi .php
# Where to look for the php.ini file?
DefaultInitEnv PHPRC        "/etc/php5/cgi"
# Maximum requests a process handles before it is terminated
MaxRequestsPerProcess       1000
# Maximum number of PHP processes
MaxProcessCount             10
# Number of seconds of idle time before a process is terminated
IPCCommTimeout              240
IdleTimeout                 240
#Or use this if you use the file above
FCGIWrapper /usr/bin/php-cgi .php



### dans le VHost de zabbix
        Alias /zabbix /usr/share/zabbix
        <Directory "/usr/share/zabbix">
                Options Indexes MultiViews ExecCGI
                AllowOverride None
                Order allow,deny
                allow from all
        </Directory>

