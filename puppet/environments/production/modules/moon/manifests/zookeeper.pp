class moon::zookeeper (
    $zookeper_version		=	'latest',
    $config_directory		= '/etc/zookeeper',
    $bin_directory		= '/opt/zookeeper',
    $dataDir			= '/var/lib/zookeeper',
    $zookeeper_port		= '2181',
    $autopurge_snapRetainCount	= '30',
    $autopurge_purgeInterval	= '3',
    $autopurge_enabled		= false,
    $zookeeper_quorum,
#    $foreman_zookeeper_hostgroup,
    $java_opts,
) {

  require moon::base
  require moon::java

  File { require => Package['zookeeper'] }

 # $zookeeper_quorum = foremanq('hosts',"hostgroup_fullname=$foreman_zookeeper_hostgroup")

  package {"zookeeper":
    ensure => $zookeeper_version,
  }
  
  if $dataDir != '/var/lib/zookeeper' {
    moon::createdir { "$dataDir": 
      owner => 'zookeeper',
      group => 'zookeeper',
    } ->
    
    file { '/var/lib/zookeeper':
      ensure => link,
      force  => true,
      target => $dataDir,
    }
  }
    file { "$dataDir/version-2":
        ensure  => directory,
        owner   => 'zookeeper',
        group   => 'zookeeper',
    }

    file { "$dataDir/myid":
        content => template("${module_name}/zookeeper/myid.erb"),
	notify  => Service['zookeeper'],
    } ->
    file { "$config_directory/zoo.cfg":
        content => template("${module_name}/zookeeper/zoo.cfg.erb"),
	notify  => Service['zookeeper'],
    } ->
    file { "/etc/sysconfig/zookeeper":
        content => template("${module_name}/zookeeper/zookeeper.erb"),
	notify  => Service['zookeeper'],
    } ~>

    service { 'zookeeper':
        ensure     => running,
        enable     => true,
        hasstatus  => true,
        hasrestart => true,
        require    => File["$dataDir/version-2"],
    }
}
