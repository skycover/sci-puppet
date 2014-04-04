class ntp {
	package { 'chrony': ensure => installed }

	file { '/etc/chrony/chrony.conf':
		mode => 644, owner => root, group => root,
		source => 'puppet:///modules/ntp/chrony.conf',
		require => Package['chrony']
	}

	service { 'chrony':
		hasrestart => true,
		subscribe => File[ '/etc/chrony/chrony.conf' ],
		require => [ Package['chrony'] ]
	}
}


