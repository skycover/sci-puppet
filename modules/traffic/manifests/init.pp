class traffic {

        package {apache2:
                ensure=> installed,
                allowcdrom => true,
        }

        file { "/etc/apache2/conf.d/lightsquid":
                owner => "root",
                group => "root",
                mode => 644,
                source => "puppet:///modules/traffic/lightsquid",
                require => Package['apache2'],
        }

        file { "/etc/lightsquid":
                owner => "root",
                group => "root",
                mode => 755,
                ensure => [ directory, present ],
                require =>  File[ "/etc/apache2/conf.d/lightsquid" ],
        }

        file { "/etc/lightsquid/lightsquid.cfg.puppet":
                owner => "root",
                group => "root",
                mode => 644,
                content => template("traffic/lightsquid.cfg.erb"),
                require => File['/etc/lightsquid'],
        }

        file { "/etc/lightsquid/lightsquid.cfg": }

        exec { "lightsquid.cfg-divert":
                command => '/usr/sbin/dpkg-divert --divert /etc/lightsquid/lightsquid.cfg.dist --rename /etc/lightsquid/lightsquid.cfg; /bin/cp -a /etc/lightsquid/lightsquid.cfg.puppet /etc/lightsquid/lightsquid.cfg',
                require =>  File[ "/etc/lightsquid/lightsquid.cfg.puppet" ],
                creates =>  [ "/etc/lightsquid/lightsquid.cfg", ],
        }

        package {lightsquid:
                ensure=> installed,
                allowcdrom => true,
                require => Exec['lightsquid.cfg-divert'],
        }

        cron { "lightparser":
                command => "/usr/share/lightsquid/lightparser.pl today > /dev/null 2>&1",
                user    => root,
                minute  => "*/10",
                ensure  => present,
                require => Package['lightsquid'],
        }
	
        package {bandwidthd:
                ensure=> installed,
                allowcdrom => true,
                require => Package['lightsquid'],
        }

        File [ '/etc/lightsquid/lightsquid.cfg' ] -> Package [ 'lightsquid' ]

}
