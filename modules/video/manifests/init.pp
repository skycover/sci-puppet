class video {

        package {zoneminder:
                ensure=> installed,
                allowcdrom => true,
        }

        file { '/etc/apache2/conf.d/zoneminder':
                ensure => 'link',
                target => '/etc/zm/apache.conf',
                require => Package['zoneminder'],
        }

        file { "/etc/zm/apache.conf": }

        exec { "/etc/init.d/apache2 reload":
                subscribe => File[ "/etc/zm/apache.conf" ],
                refreshonly => true,
                require => File['/etc/zm/apache.conf'],
        }

}

