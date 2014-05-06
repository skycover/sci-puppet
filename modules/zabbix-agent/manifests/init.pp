class zabbix-agent($zabbix_server="zabbix.$domain") {

	package {zabbix-agent:
		ensure=> installed,
		allowcdrom => true,
	}

	file { "/etc/zabbix/zabbix_agentd.conf":
		owner => "root",
		group => "root",
		mode => 644,
		content => template("zabbix-agent/zabbix_agentd.conf.erb"),
		require => Package['zabbix-agent'],
	}

	# workaround for early agent start
	if $operatingsystem == "Debian" {
		file { "/etc/insserv/overrides/zabbix-agent":
        	owner   => root,
    	    group   => root,
	        mode    => 644,
	        source  => "puppet:///modules/zabbix-agent/zabbix-agent.override",
		}
	    exec { "insserv_zabbix-agent":
			command => '/sbin/insserv zabbix-agent',
			require => [File["/etc/insserv/overrides/zabbix-agent"],Package["zabbix-agent"],],
			unless  => "/bin/ls /etc/rc2.d|/usr/bin/tail -4|/bin/grep zabbix",
		}
	}

	service { zabbix-agent:
		hasrestart => true,
		subscribe =>  File[ "/etc/zabbix/zabbix_agentd.conf" ], 
		require =>  File[ "/etc/zabbix/zabbix_agentd.conf" ], 
	}



}
