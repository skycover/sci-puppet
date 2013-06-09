class squid {

        file { "/etc/squid3":
                owner => "root",
                group => "root",
                mode => 755,
		ensure => [ directory, present ],
        }

        file { "/etc/squid3/squid.conf.puppet":
                owner => "root",
                group => "root",
                mode => 600,
                source => "puppet:///modules/squid/squid.conf",
                require =>  File[ "/etc/squid3" ],
        }

        file { "/etc/squid3/squidGuard.conf.puppet":
                owner => "root",
                group => "root",
                mode => 644,
                source => "puppet:///modules/squid/squidGuard.conf",
                require =>  File[ "/etc/squid3" ],
        }

        file { "/etc/squid3/squid.conf": }

        exec { "squid.conf-divert":
                command => '/usr/sbin/dpkg-divert --divert /etc/squid3/squid.conf.dist --rename /etc/squid3/squid.conf; /bin/cp -a /etc/squid3/squid.conf.puppet /etc/squid3/squid.conf',
                require =>  File[ "/etc/squid3/squid.conf.puppet" ],
                creates =>  [ "/etc/squid3/squid.conf", ],
        }

        exec { "squidGuard.conf-copy":
                command => '/bin/cp -a /etc/squid3/squidGuard.conf.puppet /etc/squid3/squidGuard.conf',
                require =>  File[ "/etc/squid3/squidGuard.conf.puppet" ],
                creates =>  [ "/etc/squid3/squidGuard.conf", ],
        }

        package {squid3:
                ensure=> installed,
                allowcdrom => true,
                require => Exec['squid.conf-divert'],
        }

        package {squidguard:
                ensure=> installed,
                allowcdrom => true,
                require => Package['squid3'],
        }

        File [ '/etc/squid3/squid.conf' ] -> Package [ 'squid3' ]

        exec { "/etc/init.d/squid3 restart":
                subscribe => File[ "/etc/squid3/squid.conf" ],
                refreshonly => true,
                require => Package['squid3'],
        }

        file { "/var/lib/squidguard/db/domains.good":
                owner => "proxy",
                group => "proxy",
                mode => 644,
                source => "puppet:///modules/squid/domains.good",
                require => Package['squidguard'],
        }

        file { "/var/lib/squidguard/db/urls.good":
                owner => "proxy",
                group => "proxy",
                mode => 644,
                source => "puppet:///modules/squid/urls.good",
                require => Package['squidguard'],
        }

        file { "/var/lib/squidguard/db/domains.black":
                owner => "proxy",
                group => "proxy",
                mode => 644,
                source => "puppet:///modules/squid/domains.black",
                require => Package['squidguard'],
        }

        file { "/var/lib/squidguard/db/urls.black":
                owner => "proxy",
                group => "proxy",
                mode => 644,
                source => "puppet:///modules/squid/urls.black",
                require => Package['squidguard'],
        }
}
