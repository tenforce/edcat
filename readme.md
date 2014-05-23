EDCAT
=====

EDCAT behaves is an extensible configurable indexed library of databases.  Check out our [edcat homepage](http://edcat.tenforce.com) and follow the tutorials!

Installation Guide
-------------

### Requirements

Java application server such as tomcat
Java 7
Virtuoso RDF store (recommended)
Maven
Setup

### Installation

This guide assumes you have installed virtuoso and are using tomcat 7 as your application server. It was tested on a ubuntu 12.04 installation.

First make sure all the requirements are installed:

    $ sudo apt-get install tomcat7 java7-runtime-headless virtuoso-opensource maven

Build the latest edcat version from source using the following commands:

    $ wget https://github.com/tenforce/edcat-core/archive/master.tar.gz
    $ tar xvzf edcat-core-master.tar.gz
    $ cd edcat-core-master
    $ mvn -Dmaven.test.skip=true clean package
    $ mv core/target/edcat-*.war edcat.war

Configure the location of the ext-folder by editing Tomcat’s environment variables file:

    $ echo 'JAVA_OPTS="$JAVA_OPTS -Dext.properties.dir=/usr/local/tomcat/ext/dev/"' | sudo tee -a /etc/default/tomcat7

Copy the property files to the ext folder we just configured

    $ sudo cp edcat-core-master/ext/dev/*properties /usr/local/tomcat/ext/dev/

Adjust the property files as necessary to configure the sparql connection and the public domain of the server.

    $ sudo nano /usr/local/tomcat/ext/dev/sparql.properties
    $ sudo nano /usr/local/tomcat/ext/dev/uriPattern.properties

Finally restart tomcat and copy the edcat.war file to the tomcat webapps directory

    $ sudo service tomcat7 restart
    $ sudo cp edcat.war /var/lib/tomcat7/webapps

The edcat api should now be available on http://localhost:8080/edcat. You can call http://localhost:8080/edcat/install to create an initial configuration.