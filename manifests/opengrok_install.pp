#

package { 'tomcat':
  ensure => present,
}

service { 'tomcat':
  ensure  => running,
  enable  => true,
  require => Package [ 'tomcat' ],
}


$szBaseOpenGrokPath = "/var/opengrok"
$szOpenGrokUser = "tomcat"

file { "$szBaseOpenGrokPath":
  ensure => directory,
  owner  => "$szOpenGrokUser",
}

file { "$szBaseOpenGrokPath/data":
  ensure => directory,
  owner  => "$szOpenGrokUser",
  require => File [ "$szBaseOpenGrokPath" ],
}

file { "$szBaseOpenGrokPath/src":
  ensure => directory,
  owner  => "$szOpenGrokUser",
  require => File [ "$szBaseOpenGrokPath" ],
}

file { "$szBaseOpenGrokPath/etc":
  ensure => directory,
  owner  => "$szOpenGrokUser",
  require => File [ "$szBaseOpenGrokPath" ],
}

package { 'ctags-etags':
  ensure => present,
}

$szOpenGrokName = "opengrok-0.12.1"
# opengrok-0.12.1_bin.tar.gz
# See: http://opengrok.github.io/OpenGrok/
exec { 'install_opengrok':
  creates  => "/opt/$szOpenGrokName",
  command => "cd /opt; tar -zxf /vagrant/$szOpenGrokName-bin.tar.gz",
  path    => [ '/bin/' ],
}

file { '/opt/opengrok':
  ensure  => link,
  target  => "/opt/$szOpenGrokName",
  require => Exec [ 'install_opengrok' ],
}
 
file { '/var/lib/tomcat7':
  ensure  => link,
  target  => '/var/lib/tomcat',
  require => Package [ 'tomcat' ],
}

# sudo /opt/opengrok/bin/OpenGrok deploy
exec { 'deploy_opengrok':
  creates => '/var/lib/tomcat/webapps/source.war',
  command => '/opt/opengrok/bin/OpenGrok deploy',
  path    => [ '/bin/' ],
  require => [
               File [ '/var/lib/tomcat7', "$szBaseOpenGrokPath/src" ],
               Exec [ 'install_opengrok' ],
             ],
}

# sudo /opt/opengrok/bin/OpenGrok update
exec { 'deploy_configure':
  creates => "$szBaseOpenGrokPath/etc/configuration.xml",
  command => '/opt/opengrok/bin/OpenGrok update',
  path    => [ '/bin/' ],
  require => [ 
               File [ "$szBaseOpenGrokPath/etc", "$szBaseOpenGrokPath/data" ],
               Exec [ 'deploy_opengrok' ],
             ],
}
