# == Class: opengrok
#
# Full description of class opengrok here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if
#   it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should be avoided in favor of class parameters as
#   of Puppet 2.6.)
#
# === Examples
#
#  class { opengrok:
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#  }
#
# === Authors
#
# Author Name <author@domain.com>
#
# === Copyright
#
# Copyright 2014 Your name here, unless otherwise noted.
#
# opengrok-0.12.1_bin.tar.gz
class opengrok (
  $szOpenGrokName = hiera( 'OpenGrokName', 'opengrok-0.12.1' ),
  $szFileStoragePath = hiera( 'FileStoragePath', '/vagrant/files' )
)
{

$szBaseOpenGrokPath = "/var/opengrok"
$szOpenGrokUser = "tomcat"


package { 'tomcat':
  ensure => present,
}

service { 'tomcat':
  ensure  => running,
  enable  => true,
  require => Package [ 'tomcat' ],
}


file { "$szBaseOpenGrokPath":
  ensure => directory,
  owner  => "$szOpenGrokUser",
  require => Package [ 'tomcat' ],
}

file { "$szBaseOpenGrokPath/data":
  ensure => directory,
  owner  => "$szOpenGrokUser",
  require => [
               File [ "$szBaseOpenGrokPath" ],
               Package [ 'tomcat' ],
             ],
}

file { "$szBaseOpenGrokPath/src":
  ensure => directory,
  owner  => "$szOpenGrokUser",
  require => [
               File [ "$szBaseOpenGrokPath" ],
               Package [ 'tomcat' ],
             ],
}

file { "$szBaseOpenGrokPath/etc":
  ensure => directory,
  owner  => "$szOpenGrokUser",
  require => [
               File [ "$szBaseOpenGrokPath" ],
               Package [ 'tomcat' ],
             ],
}

package { 'ctags-etags':
  ensure => present,
}

# See: http://opengrok.github.io/OpenGrok/
exec { 'install_opengrok':
  creates  => "/opt/$szOpenGrokName",
  command => "cd /opt; tar -zxf $szFileStoragePath/$szOpenGrokName-bin.tar.gz",
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
}
