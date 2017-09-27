class default_class {
	class { sources_list: stage => pre0, local_sources => yes, }
	class { common: stage => pre1, }
	class { timezone: zone => "Europe/Moscow", stage => main, }
	class { locale: def_locale => "ru_RU.UTF-8", stage => main, }
	class { ntp: stage => main, }
	class { exim4: smarthost => "default", forward_to => 'root', stage => main, }
	class { security_updates: stage => main, }
}

node 'sci' {
	class { approx_local: stage => pre0, }
	class { sources_list: stage => pre1, local_sources => yes, }
	class { common: stage => pre2, }
	class { bind9_sci: stage => main, }
	class { timezone: zone => "Europe/Moscow", stage => main, }
	class { locale: def_locale => "ru_RU.UTF-8", stage => main, }
	class { ntp: stage => main, }
	class { exim4: mailhub => yes, forward_to => 'root', stage => main, }
	class { dhcpd: enabled => yes, stage => post1, }
	class { approx_fix_cache: stage => post1, }
	class { security_updates: stage => main, }
}

node 'default' {
	require default_class
}

node 'gate' {
	require default_class
	class { iptables: stage => main, }
	class { squid: stage => main, }
	class { traffic: stage => main, }
}

