class iptables {

        file { "/usr/local/sbin/forwardport":
                owner => "root",
                group => "root",
                mode => 755,
				source => "puppet:///modules/iptables/forwardport",
        }

        file { "/etc/modprobe.d/firewall.conf":
                owner => "root",
                group => "root",
                mode => 644,
				source => "puppet:///modules/iptables/modules.conf",
        }

        file { "/etc/sysctl.d/firewall.conf":
                owner => "root",
                group => "root",
                mode => 644,
				source => "puppet:///modules/iptables/firewall.conf",
        }

        exec { "/sbin/sysctl -p /etc/sysctl.d/firewall.conf":
                subscribe => File[ "/etc/sysctl.d/firewall.conf" ],
                refreshonly => true,
                require => File[ "/etc/sysctl.d/firewall.conf" ],
        }

        package {iptables-persistent:
                ensure=> installed,
                allowcdrom => true,
        }

        file { "/etc/iptables/rules.v4.puppet":
                owner => "root",
                group => "root",
                mode => 644,
                content => template("iptables/rules.v4.erb"),
        }

        exec { "iptables-rules-copy":
                command => '/bin/cp -a /etc/iptables/rules.v4.puppet /etc/iptables/rules.v4; /bin/touch /etc/iptables/.rules.v4.touch',
                require =>  [ File[ "/etc/iptables/rules.v4.puppet" ],
                              Package[ "iptables-persistent" ], ],
                creates =>  [ "/etc/iptables/.rules.v4.touch" ],
        }

}

