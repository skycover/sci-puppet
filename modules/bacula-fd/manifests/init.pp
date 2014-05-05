class bacula-fd {

	file { "/etc/bacula/bacula-fd.conf.puppet":
		owner   => root,
		group   => root,
		mode    => 644,
		content => template("bacula-fd/bacula-fd.conf.erb"),
	}

	file { "/etc/bacula/bacula-fd.conf": }

	exec { "bacula-fd.conf-divert":
		command => '/usr/sbin/dpkg-divert --divert /etc/bacula/bacula-fd.conf.dist --rename /etc/bacula/bacula-fd.conf; /bin/cp -a /etc/bacula/bacula-fd.conf.puppet /etc/bacula/bacula-fd.conf; /bin/sed -i "s/changeme/$(/bin/cat /etc/bacula/common_default_passwords|/bin/grep FDPASSWD|/usr/bin/cut -c 10-)/" /etc/bacula/bacula-fd.conf; /bin/cat /etc/bacula/common_default_passwords|/bin/grep FDPASSWD|/usr/bin/mail root',
		require =>  File[ "/etc/bacula/bacula-fd.conf.puppet" ],
		creates =>  [ "/etc/bacula/bacula-fd.conf", ],
	}

	package {bacula-fd:
		ensure=> installed,
		allowcdrom => true,
	}

	File [ '/etc/bacula/bacula-fd.conf' ] -> Package [ 'bacula-fd' ]

	service { "bacula-fd":
		subscribe => File[ "/etc/bacula/bacula-fd.conf" ],
		hasrestart => true,
		require => Package['bacula-fd'],
	}

}
