class moon::base (
	$repo_server	=	"$::servername",
	$repo_port	=	'80',
	$packages,
) {

    yumrepo { "moon":
      descr => "Different custom built packages",
      baseurl => "http://${repo_server}:${repo_port}/yum-$environment",
      enabled => 1,
      gpgcheck => 0,
      metadata_expire => '10m',
    }
    
    package { $packages:
	ensure => installed,
    }

    file {"opt":
      path => '/opt',
      ensure => directory,
    }

    file {'/etc/xinetd.conf':
      mode => '0600',
      owner => 'root',
      group => 'root',
    }

    user {'ftp':
      ensure => absent,
    }

#    host { "$hostname_fqdn":
#      ip => $ipaddress,
#      host_aliases => "$hostname",
#    }
}
