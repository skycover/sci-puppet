class bareos {

	package {postgresql:
		ensure=> installed,
		allowcdrom => true,
	}
	
        package {bareos:
                ensure=> installed,
                allowcdrom => true,
                require => Package['postgresql'],
        }
	
	file { "/etc/bareos/bareos-dir.conf":
                owner => "root",
                group => "root",
                mode => "644",
                source => "puppet:///modules/bareos/bareos-dir.conf",
                require => Package['bareos'],
        }
	
	file { "/etc/bareos/bareos-dir.d/jobdefs/file-data.conf":
		owner => "root",
                group => "root",
                mode => "644",
                source => "puppet:///modules/bareos/file-data.conf",
                require => File['/etc/bareos/bareos-dir.conf'],
        }

	file { "/etc/bareos/bareos-dir.d/jobdefs/home.conf":
                owner => "root",
                group => "root",
                mode => "644",
                source => "puppet:///modules/bareos/home.conf",
                require => File['/etc/bareos/bareos-dir.d/jobdefs/file-data.conf'],
        }

	file { "/etc/bareos/bareos-dir.d/jobdefs/windows-data.conf":
                owner => "root",
                group => "root",
                mode => "644",
                source => "puppet:///modules/bareos/windows-data.conf",
                require => Package['bareos'],
        }

	exec { "/bin/su - postgres -c /usr/lib/bareos/scripts/make_bareos_tables":
                require => Package['postgresql', 'bareos'],
		creates => '/etc/bareos/tables_added'
        }

	exec { "/bin/su - postgres -c /usr/lib/bareos/scripts/grant_bareos_privileges":
                require => [Exec["/bin/su - postgres -c /usr/lib/bareos/scripts/make_bareos_tables"], Package['postgresql', 'bareos']],
		creates => '/etc/bareos/tables_added'
        }

	exec { 'tables done':
		require => [Exec["/bin/su - postgres -c /usr/lib/bareos/scripts/make_bareos_tables"], Exec["/bin/su - postgres -c /usr/lib/bareos/scripts/grant_bareos_privileges"]],
		command => "/usr/bin/touch /etc/bareos/tables_added",
		creates => '/etc/bareos/tables_added'
	}

	service { "bareos-dir":
                subscribe => File[ "/etc/bareos/bareos-dir.conf" ],
                hasrestart => true,
		ensure => true,
                require => [Package['bareos'], File['/etc/bareos/bareos-dir.d/jobdefs/windows-data.conf'], Exec['/bin/su - postgres -c /usr/lib/bareos/scripts/grant_bareos_privileges']],
        }
	service { "bareos-sd":
                subscribe => File[ "/etc/bareos/bareos-dir.conf" ],
                hasrestart => true,
		ensure => true,
                require => [Package['bareos'], Exec['/bin/su - postgres -c /usr/lib/bareos/scripts/grant_bareos_privileges'], File['/etc/bareos/bareos-dir.d/jobdefs/windows-data.conf']]
        }
	

}
