node 'default' {
	class { sources_list_local: stage => pre0, }
	class { common_profile: stage => pre1, }
	class { timezone: zone => "Europe/Moscow", stage => main, }
	class { locale: def_locale => "ru_RU.UTF-8", stage => main, }
	class { exim4: smarthost => "default", forward_to => 'root', stage => main, }
}

node 'gate' inherits default {
	class { iptables: stage => main, }
	class { squid: stage => main, }
	class { traffic: stage => main, }
}

node 'sci' {
	class { approx_local: stage => pre0, }
	class { sources_list_local: stage => pre1, }
	class { common_profile: stage => pre2, }
	class { bind9_sci: stage => main, }
	class { timezone: zone => "Europe/Moscow", stage => main, }
	class { locale: def_locale => "ru_RU.UTF-8", stage => main, }
	class { exim4: mailhub => yes, forward_to => 'root', stage => main, }
	class { dhcpd: enabled => no, stage => post1, }
	class { approx_fix_cache: stage => post1, }
}
