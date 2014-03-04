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
		]:
		ensure => installed
	}

	file { '/root/.bashrc':
		mode => 644, owner => root, group => root,
		source => 'puppet:///modules/common/root_bashrc'
	}

	package { 'sysstat': ensure => installed }

	file { '/etc/default/sysstat':
		mode => 644, owner => root, group => root,
		source => 'puppet:///modules/common/sysstat_default',
		require => Package['sysstat']
	}

	package { 'vim': ensure => installed }

	file { 'vimrc.local':
		name => '/etc/vim/vimrc.local',
		mode => 644, owner => root, group => root,
		source => 'puppet:///modules/common/vimrc.local',
		require => Package['vim']
	}

	check_alternatives { 'editor':
		linkto => '/usr/bin/vim.basic',
		package => "vim",
	}

}
