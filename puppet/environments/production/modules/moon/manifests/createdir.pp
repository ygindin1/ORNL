define moon::createdir (
   $owner = 'root',
   $group = 'root',
   $mode  = '0755',
) {

  validate_absolute_path($name)

  exec { "mkdir_p-${name}":
    command => "mkdir -p ${name}",
    unless  => "test -d ${name}",
    path    => '/bin:/usr/bin',
  } ->
  
  file { "$name":
    owner => $owner,
    group => $group,
    mode  => $mode,
    ensure => directory,
  }
}
