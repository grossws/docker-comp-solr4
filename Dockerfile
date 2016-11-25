FROM grossws/tomcat8
MAINTAINER Konstantin Gribov <grossws@gmail.com>

ENV XTYPE solr
WORKDIR /opt

# see https://www.apache.org/dist/lucene/KEYS
RUN gpg --keyserver pgp.mit.edu --recv-keys \
  4B96409A098DBD511DF2BC18DBAF69BEA7239D59 \
  A46D8682A850E44E4FEC20EB8A8A771FFE045966 \
  4DDFABAF68C0F906B76CD9A09C784577F8F58E19 \
  F91063BBBFA9408B2ED661023FBFD18278796AC8 \
  2C72EB1397733A551DDB60CCF119941F6E68DA61 \
  66619BA3C030DD5536251303817AE1DD322D7ECA \
  38D2EA16DDF5FC722EBC433FDC92616F177050F6 \
  50BE56C1086BF13AE96246F76C5A4F6DECA39416 \
  0186F8B24C5BC02C94A0E0E486F75E83E1EE085F \
  A9444FB7DB71EFE47A9FCF0F88E27CA20ED7633F \
  12FC1967EAE1BA39B9FFF28FA8702226EF526FA1 \
  5F55943E13D49059D3F342777186B06E1ED139E7 \
  D92CDD2BC55E4D921CFA708DE9F3B24698483DC3 \
  3558857D1F5754B78C7F8B5A71A45A3D0D8D0B93 \
  D7DD1CAC3361852FDCBEDB1BDC7BF9853C1E73F8 \
  0143E2AA6983731F9D1DD82A2184C00ABBCD7E0E \
  E6E21FFCDCEA14C95910EA65051A0FAF76BC6507 \
  C502FA4936D30F098205207304B0610E75120CA4 \
  75952CF677CC8173F8E254D6F1A1F48B521A0277 \
  6B7DC27D3EEF44F3015074C5ABE9C5D21EFAFD39 \
  EDF961FF03E647F9CA8A9C2C758051CCA3A13A7F

ARG SOLR_VERSION=4.10.4
ARG SOLR_TGZ_URL=https://archive.apache.org/dist/lucene/solr/$SOLR_VERSION/solr-$SOLR_VERSION.tgz

RUN sed -i 's/8080/8983/' /opt/tomcat/conf/server.xml \
  && mkdir -p /opt/solr/{data,conf,lib} \
  && curl -sSL $SOLR_TGZ_URL -o solr.tar.gz \
  && curl -sSL $SOLR_TGZ_URL.asc -o solr.tar.gz.asc \
  && gpg --verify solr.tar.gz.asc solr.tar.gz \
  && tar xvf solr.tar.gz -C /opt/tomcat/lib --strip-components=4 solr-$SOLR_VERSION/example/lib/ext/\*.jar \
  && tar xvf solr.tar.gz -C /opt/solr --strip-components=2 solr-$SOLR_VERSION/dist/solr-$SOLR_VERSION.war \
  && tar xvf solr.tar.gz -C /opt/solr --strip-components=1 solr-$SOLR_VERSION/LICENSE.txt solr-$SOLR_VERSION/NOTICE.txt \ 
  && mv solr/solr-$SOLR_VERSION.war solr/solr.war \
  && mv solr/LICENSE.txt solr/LICENSE \
  && mv solr/NOTICE.txt solr/NOTICE \
  && echo "name = core0" > /opt/solr/core.properties \
  && rm solr.tar.gz*

ADD log4j.properties /opt/tomcat/lib/
ADD catalina-solr.xml /opt/tomcat/conf/Catalina/localhost/solr.xml
ADD solr.xml /opt/solr/

VOLUME ["/opt/solr/data"]
EXPOSE 8983

