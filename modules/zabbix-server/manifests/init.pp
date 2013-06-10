class zabbix-server {

        package {pwgen:
                ensure=> installed,
                allowcdrom => true,
        }

        package {zabbix-server-mysql:
                ensure=> installed,
                allowcdrom => true,
                require => Package['pwgen'],
        }

        package {zabbix-frontend-php:
                ensure=> installed,
                allowcdrom => true,
                require => Package['zabbix-server-mysql'],
        }

        file { "/etc/zabbix/zabbix_server.conf.puppet":
                owner => "zabbix",
                group => "zabbix",
                mode => 600,
                source => "puppet:///modules/zabbix-server/zabbix_server.conf",
                require => Package['zabbix-frontend-php'],
        }

        file { "/etc/default/zabbix-server":
                owner => "root",
                group => "root",
                mode => 644,
                source => "puppet:///modules/zabbix-server/zabbix-server",
                require => Package['zabbix-frontend-php'],
        }

        file { "/etc/zabbix/zabbix.conf.php.puppet":
                owner => "www-data",
                group => "zabbix",
                mode => 600,
                source => "puppet:///modules/zabbix-server/zabbix.conf.php",
                require => Package['zabbix-frontend-php'],
        }

        file { "/usr/local/share/zabbix-server-mysql":
                owner => "root",
                group => "root",
                mode => 755,
                ensure => [ directory, present ],
                require => Package['zabbix-frontend-php'],
        }

        file { "/usr/local/share/zabbix-server-mysql/zabbix-server-mysql.sql":
                owner => "root",
                group => "root",
                mode => 644,
                source => "puppet:///modules/zabbix-server/zabbix-server-mysql.sql",
                require => File['/usr/local/share/zabbix-server-mysql'],
        }

        file { "/usr/local/sbin/zabbix-install-db":
                owner => "root",
                group => "root",
                mode => 755,
                source => "puppet:///modules/zabbix-server/zabbix-install-db",
                require => Package['zabbix-frontend-php'],
        }

        file { "/etc/apache2/conf.d/zabbix":
                owner => "root",
                group => "root",
                mode => 644,
                source => "puppet:///modules/zabbix-server/zabbix",
                require => Package['zabbix-frontend-php'],
        }

        file { "/etc/php5/apache2/php.ini":
                owner => "root",
                group => "root",
                mode => 644,
                source => "puppet:///modules/zabbix-server/php.ini",
                require => Package['zabbix-frontend-php'],
        }

        exec { "install-zabbix-db":
                command => "/usr/local/sbin/zabbix-install-db",
                creates => "/etc/zabbix/.puppet-disable",
                require => File[ "/etc/zabbix/zabbix_server.conf.puppet", "/etc/zabbix/zabbix.conf.php.puppet", "/usr/local/sbin/zabbix-install-db", "/etc/apache2/conf.d/zabbix", "/usr/local/share/zabbix-server-mysql/zabbix-server-mysql.sql", "/etc/php5/apache2/php.ini", "/etc/default/zabbix-server" ],
        }

        service { zabbix-server:
                hasrestart => true,
                subscribe =>  File[ "/etc/zabbix/zabbix_server.conf.puppet" ],
                require => Exec[ "install-zabbix-db" ],
        }

        service { apache2:
                hasrestart => true,
                subscribe =>  File[ "/etc/apache2/conf.d/zabbix" ],
                require => Exec[ "install-zabbix-db" ],
        }

}
