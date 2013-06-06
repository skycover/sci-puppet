class bacula-fd {

        package {bacula-fd:
                ensure=> installed,
                allowcdrom => true,
        }

        file { "/etc/bacula/bacula-fd.conf.puppet":
                owner   => root,
                group   => root,
                mode    => 644,
                content => template("bacula-fd/bacula-fd.conf.erb"),
                require => Package["bacula-fd"],
        }

        exec { "sed_config_bacula-fd":
                command => '/bin/cp /etc/bacula/bacula-fd.conf.puppet /etc/bacula/bacula-fd.conf; /bin/sed -i "s/changeme/$(/bin/cat /etc/bacula/common_default_passwords|/bin/grep FDPASSWD|/usr/bin/cut -c 10-)/" /etc/bacula/bacula-fd.conf; /etc/init.d/bacula-fd restart; /bin/cat /etc/bacula/common_default_passwords|/bin/grep FDPASSWD|/usr/bin/mail root',
                require => File["/etc/bacula/bacula-fd.conf.puppet"],
                subscribe => File["/etc/bacula/bacula-fd.conf.puppet"],
                unless  => "/bin/grep $(hostname -f) /etc/bacula/bacula-fd.conf",
        }

}
