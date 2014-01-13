class ethtool {

	package {ethtool:
		ensure=> installed,
		allowcdrom => true,
	}

# in wheezy var $virtual not working
#if $virtual == 'xenu' {
	file { "/etc/network/if-up.d/disable-tx-offload":
		owner => "root",
		group => "root",
		mode => 755,
		source => "puppet:///modules/ethtool/disable-tx-offload",
		require => Package[ethtool],
	}
#}

}
