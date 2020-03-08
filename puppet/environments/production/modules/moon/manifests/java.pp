class moon::java (
        $java_version   =       'jdk1.8.0_232',
) {

   package {"$java_version":
        ensure => installed,
	require => Yumrepo['moon'],
   }
}
