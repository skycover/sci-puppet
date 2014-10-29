# timezone module from https://github.com/attachmentgenie/puppet-module-timezone
class timezone($zone='UTC') {
  package { 'tzdata':
    ensure => latest,
  }

  file { '/etc/timezone':
    content => inline_template('<%= zone + "\n" %>'),
  }

  exec { 'reconfigure-tzdata':
    command => '/usr/sbin/dpkg-reconfigure -f noninteractive tzdata',
    subscribe => File['/etc/timezone'],
    require => File['/etc/timezone'],
    refreshonly => true,
  }
}

