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
http://127.0.0.1:8080/source

Update index:
/opt/opengrok/bin/OpenGrok index




# Troubleshooting


####
/opt/opengrok/bin/OpenGrok index
Loading the default instance configuration ...
Exception: /var/opengrok/etc/configuration.xml (Permission denied)
06:30:57 SEVERE: Unexpected Exception
java.io.FileNotFoundException: /var/opengrok/etc/configuration.xml (Permission denied)
        at java.io.FileOutputStream.open(Native Method)
        at java.io.FileOutputStream.<init>(FileOutputStream.java:221)
        at java.io.FileOutputStream.<init>(FileOutputStream.java:171)
        at org.opensolaris.opengrok.configuration.Configuration.write(Configuration.java:758)
        at org.opensolaris.opengrok.configuration.RuntimeEnvironment.writeConfiguration(RuntimeEnvironment.java:917)
        at org.opensolaris.opengrok.index.Indexer.prepareIndexer(Indexer.java:729)
        at org.opensolaris.opengrok.index.Indexer.main(Indexer.java:551)
[vagrant@localhost henk52-opengrok]$ ls -l /var/opengrok/etc/configuration.xml
-rw-r--r-- 1 root root 1302 Nov 23 23:46 /var/opengrok/etc/configuration.xml

