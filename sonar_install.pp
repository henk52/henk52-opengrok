#
#class { 'tomcat': }
#tomcat::instance{ 'default':
#  install_from_source => false,
#  package_name        => 'tomcat',
#} -> tomcat::service { 'default': }


package { 'tomcat':
  ensure => present,
}

service { 'tomcat':
  ensure  => running,
  enable  => true,
  require => Package [ 'tomcat' ],
}



cadm@hpw:~/vagrants$ cat tomcat_install.pp
#
#class { 'tomcat': }
#tomcat::instance{ 'default':
#  install_from_source => false,
#  package_name        => 'tomcat',
#} -> tomcat::service { 'default': }


package { 'tomcat':
  ensure => present,
}

service { 'tomcat':
  ensure  => running,
  enable  => true,
  require => Package [ 'tomcat' ],
}
