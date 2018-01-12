class bareos_fd {

	package {bareos-filedaemon:
		ensure=> installed,
		allowcdrom => true,
	}

	exec { mail_pwd:
		command => '/bin/cat /etc/bareos/.rndpwd|/bin/grep CLIENT_PASSWORD| mail root; touch /etc/bareos/.first-flag.puppet',
		creates => '/etc/bareos/.first-flag.puppet',
		subscribe => Package['bareos-filedaemon'],
	}
	service { "bareos-fd":
		hasrestart => true,
		require => Package['bareos-filedaemon'],
		subscribe => Package['bareos-filedaemon'],
	}

}
