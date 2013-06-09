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

        service { zabbix-agent:
                hasrestart => true,
                subscribe =>  File[ "/etc/zabbix/zabbix_agentd.conf" ],
                require =>  File[ "/etc/zabbix/zabbix_agentd.conf" ],
        }

}
