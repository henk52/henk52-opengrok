henk52-opengrok
===============

Puppet module for OpenGrok installation
opengrok

This is the opengrok module.

License
-------


Contact
-------


Support
-------

Please log tickets and issues at our [Projects site](http://projects.example.com)


You need to get hold of the opengrok-0.12.1-bin.tar.gz to get this to work.
 e.g.:
  1) mkdir -p /vagrant/files
  2) cd  /vagrant/files
  3) wget http://10.1.2.3:/storage/opengrok-0.12.1-bin.tar.gz

### Testing it out
sudo ln -s /vagrant/modules/henk52-opengrok /etc/puppet/modules/opengrok
sudo puppet apply /vagrant/modules/henk52-opengrok/tests/init.pp

Access:
http://127.0.0.1:8080/sources


