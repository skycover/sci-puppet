class denyhosts {

# dummy code
file { "/tmp/nonexist.denyhosts": }

if $lsbdistcodename != trusty {
	package { denyhosts: ensure => installed }

	file { "/etc/denyhosts.conf":
		owner   => root,
		group   => root,
		mode    => 644,
		source  => "puppet:///modules/denyhosts/denyhosts.conf",
		require => Package["denyhosts"],
	}

	file { "/etc/hosts.allow":
		owner   => root,
		group   => root,
		mode    => 644,
		source  => "puppet:///modules/denyhosts/hosts.allow",
		require => Package["denyhosts"],
	}

	file { "/var/lib/denyhosts/allowed-hosts":
		owner   => root,
		group   => root,
		mode    => 600,
		source  => "puppet:///modules/denyhosts/allowed-hosts",
		require => Package["denyhosts"],
	}

	service { denyhosts:
		ensure => running,
		hasrestart => true,
		subscribe => File["/etc/denyhosts.conf"],
	}
}

}

