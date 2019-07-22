class approx {
}

# approx part to deploy the local repos and cd-rom
class approx_local {
	include approx
	$gpgdir = "/etc/sci/gpg"
	$release = "/media/sci/dists/$lsbdistcodename/Release"
	$approxModule = "/etc/puppet/modules/approx"

	file { "/etc/sci":
		owner => "root",
		group => "root",
		mode => "0755",
		ensure => [directory, present],
	}
	file { "$gpgdir":
		owner => "root",
		group => "root",
		mode => "0700",
		ensure => [directory, present],
	}
	file { "$gpgdir/sci-genkey.sh":
		owner => "root",
		group => "root",
		mode => "0700",
		source => 'puppet:///modules/approx/sci-genkey.sh',
		require => File["$gpgdir"],
	}
	file { "$gpgdir/sci-key-input":
		owner => "root",
		group => "root",
		mode => "0700",
		content => template("approx/sci-key-input.erb"),
		require => File["$gpgdir"],
	}
	file { "$gpgdir/sci.pub": }
	exec { approx_gen_key:
		command => "$gpgdir/sci-genkey.sh",
		creates => "$gpgdir/sci.pub",
		require => File["$gpgdir/sci-key-input"],
	}
	file { "$release": }
	file { "$release.gpg": }
	file { "$gpgdir/secring.gpg": }
	file { "$approxModule/files/sci.pub": }
	exec { approx_sign_local_release:
		command => "/usr/bin/gpg --homedir $gpgdir --sign -abs -o $release.gpg $release",
		creates => "$release.gpg",
		require => [Exec["approx_gen_key"], File["$gpgdir/sci.pub", "$release"]],
	}
	exec { approx_publish_key:
		command => "/bin/cp $gpgdir/sci.pub /etc/puppet/modules/approx/files/sci.pub",
		creates => "/etc/puppet/modules/approx/files/sci.pub",
		require => [Exec["approx_sign_local_release"], File["$gpgdir/sci.pub", "$release.gpg"]],
	}
	package { 'approx': ensure => installed, allowcdrom => true } 

	file { "/etc/approx/approx.conf":
		owner => "root",
		group => "root",
		mode => "0644",
		content => template("approx/approx.conf.erb"),
		require => Package['approx'],
	}
}

# sources.list with apt key for local repos
class sources_list($local_sources=yes) {
	if $local_sources == yes {
		if defined(File['/etc/sci']) == false {
		file { "/etc/sci":
			owner => "root",
			group => "root",
			mode => "0755",
			ensure => [directory, present],
			}
		}

		file { "/etc/sci/sci.pub":
			owner => "root", group => "root", mode => "0644",
			source => 'puppet:///modules/approx/sci.pub',
			require => File["/etc/sci"],
		}
		exec { apt-key-add-sci:
			command => "/usr/bin/apt-key add /etc/sci/sci.pub",
			require => File["/etc/sci/sci.pub"],
			subscribe => File["/etc/sci/sci.pub"],
			notify => Exec["apt-get-update"],
			refreshonly => true,
		}
	}

	if $operatingsystem == "Debian" {
		if $lsbdistcodename == "squeeze" {
			file { "/etc/apt/sources.list":
				owner => "root", group => "root", mode => "0644",
				content => template("approx/sources.list.squeeze.erb"),
			}
		} else {
			file { "/etc/apt/sources.list":
				owner => "root", group => "root", mode => "0644",
				content => template("approx/sources.list.erb"),
			}
		}

	}
	if $operatingsystem == "Ubuntu" {
		file { "/etc/apt/sources.list":
			owner => "root", group => "root", mode => "0644",
			content => template("approx/sources.list.ubuntu.erb"),
		}
	}
	file { "/etc/apt/apt.conf.d/11periodic":
		owner => "root", group => "root", mode => "0644",
		source => 'puppet:///modules/approx/11periodic',
	}
	file { "/etc/apt/apt.conf.d/99stable":
		owner => "root", group => "root", mode => "0644",
		source  => $lsbdistcodename ? {
			'squeeze' => 'puppet:///modules/approx/99stable.squeeze',
			'wheezy' => 'puppet:///modules/approx/99stable.wheezy',
			'jessie' => 'puppet:///modules/approx/99stable.jessie',
			'lenny' => 'puppet:///modules/approx/99stable.lenny',
			'precise' => 'puppet:///modules/approx/99stable.precise',
			'trusty' => 'puppet:///modules/approx/99stable.trusty',
			'xenial' => 'puppet:///modules/approx/99stable.xenial',
			'stretch' => 'puppet:///modules/approx/99stable.stretch',
			'buster' => 'puppet:///modules/approx/99stable.buster',
			default => 'puppet:///modules/approx/99stable.wheezy',
		},
	}
	if $local_sources == yes {
		exec{ apt-get-update:
			command => '/usr/bin/apt-get update',
			refreshonly => true,
			require => File["/etc/sci/sci.pub"],
			subscribe => File['/etc/apt/sources.list'],
            returns => [0,100],
		}
	} else {
		exec{ apt-get-update:
			command => '/usr/bin/apt-get update',
			refreshonly => true,
			subscribe => File['/etc/apt/sources.list'],
		}
	}
}

# workaround for http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=655986
class approx_fix_cache {
	if defined(Package['approx']) == true {
		exec {'fix-approx-cache':
			command => '/usr/bin/find /var/cache/approx -empty -type f -perm 0000 -delete; /usr/bin/find /var/cache/approx -mindepth 1 -empty -type d -delete; echo "43 3 * * * root find /var/cache/approx -empty -type f -perm 0000 -delete; find /var/cache/approx -mindepth 1 -empty -type d -delete" > /etc/cron.d/approx-fix-cache',
			creates => '/etc/cron.d/approx-fix-cache',
		}
	}
}

