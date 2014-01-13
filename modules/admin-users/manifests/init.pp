# class for ruling admin users and its passwords
class admin-users {

	user { 'admin':
		ensure      => present,
		uid         => 1100,
		gid         => 'sudo',
		password    => 'use_mkpasswd_to_generate_sha512_hash',
		shell       => '/bin/bash',
		home        => '/home/admin',
		managehome  => 'true',
	}
        
	user { 'root':
		password    => 'use_mkpasswd_to_generate_sha512_hash',
		ensure      => present,
		gid         => 'root',
		shell       => '/bin/bash',
		home        => '/root',
	}

}

