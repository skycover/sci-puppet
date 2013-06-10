class web {

        package {nginx-full:
                ensure=> installed,
                allowcdrom => true,
        }

        package {php5-common:
                ensure=> installed,
                allowcdrom => true,
        }
        package {php5-fpm:
                ensure=> installed,
                allowcdrom => true,
        }
        package {php5-cli:
                ensure=> installed,
                allowcdrom => true,
        }
        package {php5-curl:
                ensure=> installed,
                allowcdrom => true,
        }
        package {php5-gd:
                ensure=> installed,
                allowcdrom => true,
        }
        package {php5-imap:
                ensure=> installed,
                allowcdrom => true,
        }
        package {php5-intl:
                ensure=> installed,
                allowcdrom => true,
        }
        package {php5-ldap:
                ensure=> installed,
                allowcdrom => true,
        }
        package {php5-mcrypt:
                ensure=> installed,
                allowcdrom => true,
        }
        package {php5-mysql:
                ensure=> installed,
                allowcdrom => true,
        }
        package {php5-pgsql:
                ensure=> installed,
                allowcdrom => true,
        }
        package {php5-pspell:
                ensure=> installed,
                allowcdrom => true,
        }

        package {mysql-server:
                ensure=> installed,
                allowcdrom => true,
        }

        package {pwgen:
                ensure=> installed,
                allowcdrom => true,
        }

        file { "/var/run/php5-fpm":
                owner => "root",
                group => "root",
                mode => 755,
                ensure => [ directory, present ],
        }

        file { "/etc/add-site":
                owner => "root",
                group => "root",
                mode => 755,
                ensure => [ directory, present ],
        }

        file { "/etc/add-site/nginx.template":
                owner => "root",
                group => "root",
                mode => 644,
                source => "puppet:///modules/web/nginx.template",
        }

        file { "/etc/add-site/php-fpm.template":
                owner => "root",
                group => "root",
                mode => 644,
                source => "puppet:///modules/web/php-fpm.template",
        }

        file { "/usr/local/sbin/add-site":
                owner => "root",
                group => "root",
                mode => 755,
                source => "puppet:///modules/web/add-site",
        }

        file { "/usr/local/sbin/nginx_ensite":
                owner => "root",
                group => "root",
                mode => 755,
                source => "puppet:///modules/web/nginx_ensite",
        }

        file { "/etc/nginx/sites-available/default":
                owner => "root",
                group => "root",
                mode => 644,
                source => "puppet:///modules/web/default",
                require => Package['nginx-full'],
        }

}
