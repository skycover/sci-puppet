import "lib.pp"

class common {

	package {
		[ 'less',
		  'psmisc',
		  'dnsutils',
		  'sudo',
		  'bash-completion',
		  'zsh',
		  'htop',
		  'man',
		  'lsb-release',
		  'aptitude',
		]:
		ensure => installed,
		allowcdrom => true,
	}

	file { '/root/.bashrc':
		mode => "644", owner => root, group => root,
		source => 'puppet:///modules/common/root_bashrc'
	}

	package { 'sysstat': ensure => installed }

	file { '/etc/default/sysstat':
		mode => "644", owner => root, group => root,
		source => 'puppet:///modules/common/sysstat_default',
		require => Package['sysstat']
	}

	package { 'vim': ensure => installed }

	file { 'vimrc.local':
		name => '/etc/vim/vimrc.local',
		mode => "644", owner => root, group => root,
		source => 'puppet:///modules/common/vimrc.local',
		require => Package['vim']
	}

	#check_alternatives { 'editor':
	#	linkto => '/usr/bin/vim.basic',
	#	package => "vim",
	#}

	# enable pluginsync
	#exec { "enable pluginsync":
	#	command =>  '/bin/sed -i \'/\[main\]/ a\pluginsync = true\' /etc/puppet/puppet.conf',
	#	unless => '/usr/bin/awk \'/\[main\]/ { getline; print $0 }\' /etc/puppet/puppet.conf|/bin/grep -q pluginsync',
	#}

	#file { '/etc/puppet/puppet.conf': }

	#service { puppet:
	#	hasrestart => true,
	#	subscribe =>  File[ "/etc/puppet/puppet.conf" ],
	#	require =>  Exec[ "enable pluginsync" ],
	#}

}
