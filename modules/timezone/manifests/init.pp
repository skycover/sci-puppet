# timezone module from https://github.com/attachmentgenie/puppet-module-timezone
class timezone($zone='UTC') {
  package { 'tzdata':
    ensure => latest,
  }

  file { '/etc/timezone':
    content => inline_template('<%= @zone + "\n" %>'),
  }
  
  file { '/etc/localtime':
    ensure => link,
    target => "/usr/share/zoneinfo/$zone",
  }
  exec { 'reconfigure-tzdata':
    command => '/usr/sbin/dpkg-reconfigure -f noninteractive tzdata',
    subscribe => File['/etc/localtime'],
    require => File['/etc/localtime'],
    refreshonly => true,
  }
}

