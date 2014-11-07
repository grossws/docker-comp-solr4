FROM grossws/tomcat8
MAINTAINER Konstantin Gribov <grossws@gmail.com>

# configure tomcat
RUN sed -i 's/8080/8983/' /opt/tomcat/conf/server.xml

# install logger libs from solr-4.10.1/example/lib/ext:
ADD lib-ext.tar.gz /opt/tomcat/lib/
ADD log4j.properties /opt/tomcat/lib/

# install and configure solr
ADD catalina-solr.xml /opt/tomcat/conf/Catalina/localhost/solr.xml
ADD solr.xml /opt/solr/
RUN echo "name = core0" > /opt/solr/core.properties

WORKDIR /opt
VOLUME ["/opt/solr/data"]
EXPOSE 8983

ADD solr-4.10.2.war /opt/solr.war

