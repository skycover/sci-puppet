# exim4 config class
# if node is satellite(forward system mail to external mailbox $forward_to), you must set $smarthost and $forward_to, eg smarthost=mail-relay.somedomain; forward_to=some-mailbox@somewhere
# if node is mailhub(receive mail locally to user $forward_to), you must set $mailhub=yes
class exim4($smarthost='',$mailhub='no',$forward_to='root') {

	package { exim4: ensure => installed }

	file { "/etc/mailname":
		owner   => root,
		group   => root,
		mode    => "644",
		content => template("exim4/mailname.erb"),
	}

	if $mailhub == 'yes' {
		file { "/etc/exim4/update-exim4.conf.conf":
			owner   => root,
			group   => root,
			mode    => "644",
			require => Package["exim4"],
			content => template("exim4/update-exim4.conf.conf-mailhub.erb"),
		}
	}
	else {
		file { "/etc/exim4/update-exim4.conf.conf":
			owner   => root,
			group   => root,
			mode    => "644",
			require => Package["exim4"],
			content => template("exim4/update-exim4.conf.conf-satellite.erb"),
		}
	}

#	$smarthost = $smarthost ? {
#		default => "sci.{domain}"
#		$smarthost

	exec { "/usr/sbin/update-exim4.conf":
		subscribe => File[ "/etc/exim4/update-exim4.conf.conf" ],
		refreshonly => true,
		require => File[ "/etc/exim4/update-exim4.conf.conf" ],
	}

	service { exim4:
		hasrestart => true,
		subscribe =>  File[ "/etc/exim4/update-exim4.conf.conf", "/etc/mailname" ],
		require => [ File[ "/etc/exim4/update-exim4.conf.conf" ], File[ "/etc/mailname" ], Exec["/usr/sbin/update-exim4.conf"]],
	}

	mailalias { security:
		ensure => present,
		name => security,
		recipient => "root",
	}
	mailalias { nobody:
		ensure => present,
		name => nobody,
		recipient => "root",
	}
	mailalias { admins:
		ensure => present,
		name => root,
		recipient => "$forward_to",
	}
}
