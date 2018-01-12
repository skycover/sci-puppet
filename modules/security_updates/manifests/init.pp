# security updates class
class security_updates {

	package { openssh-server: ensure => latest }

# GHOST
    package { libc-bin: ensure => latest }

# hearbleed
	if $operatingsystem == "Debian" {
		if $lsbdistcodename == "wheezy" {
			if $package_openssl == "true" {
				package { "openssl": ensure => latest }
			}
			if $package_libssl100 == "true" {
				package { "libssl1.0.0": ensure => latest }
			}
		}
	}
}
