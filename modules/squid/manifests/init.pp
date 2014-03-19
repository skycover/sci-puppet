class squid {

        file { "/etc/squid":
                owner => "root",
                group => "root",
                mode => 755,
		ensure => [ directory, present ],
        }

        file { "/etc/squid/squid.conf.puppet":
                owner => "root",
                group => "root",
                mode => 600,
                source => "puppet:///modules/squid/squid.conf",
                require =>  File[ "/etc/squid" ],
        }

        file { "/etc/squid/squidGuard.conf.puppet":
                owner => "root",
                group => "root",
                mode => 644,
                source => "puppet:///modules/squid/squidGuard.conf",
                require =>  File[ "/etc/squid" ],
        }

        file { "/etc/squid/squid.conf": }

        exec { "squid.conf-divert":
                command => '/usr/sbin/dpkg-divert --divert /etc/squid/squid.conf.dist --rename /etc/squid/squid.conf; /bin/cp -a /etc/squid/squid.conf.puppet /etc/squid/squid.conf',
                require =>  File[ "/etc/squid/squid.conf.puppet" ],
                creates =>  [ "/etc/squid/squid.conf", ],
        }

        exec { "squidGuard.conf-copy":
                command => '/bin/cp -a /etc/squid/squidGuard.conf.puppet /etc/squid/squidGuard.conf',
                require =>  File[ "/etc/squid/squidGuard.conf.puppet" ],
                creates =>  [ "/etc/squid/squidGuard.conf", ],
        }

        package {squid:
                ensure=> installed,
                allowcdrom => true,
                require => Exec['squid.conf-divert'],
        }

        package {squidguard:
                ensure=> installed,
                allowcdrom => true,
                require => Package['squid'],
        }

        File [ '/etc/squid/squid.conf' ] -> Package [ 'squid' ]

        exec { "/etc/init.d/squid restart":
                subscribe => File[ "/etc/squid/squid.conf" ],
                refreshonly => true,
                require => Package['squid'],
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
