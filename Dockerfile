FROM grossws/tomcat8
MAINTAINER Konstantin Gribov <grossws@gmail.com>

WORKDIR /opt

# see https://www.apache.org/dist/lucene/KEYS
RUN gpg --keyserver pgp.mit.edu --recv-keys \
	673D70920C5519357E7DB73B97C17141BC434270 \
	8FE7A0B24B77E888EF5A5CE8ABC8EE39BB550746 \
	6BDACA2C0493CCA133B372D09C4F7E9D98B1CC53 \
	4B96409A098DBD511DF2BC18DBAF69BEA7239D59 \
	A46D8682A850E44E4FEC20EB8A8A771FFE045966 \
	9568C771494DDF441E8E2C233C9A42040C0885B4 \
	3B54246B0B51FC0C08C254DA03A6BA78B1703929 \
	43AF49415CEC8D83C7895F47992AFEEEC09FB546 \
	EAA526B91DD83BA3E1B9636FA730529CA355A63E \
	402F685604A7EFD6FA2BDFD850634F398A26D9A6 \
	868EE1DF446399F9FA73E3BB655E4BF442CFAE07 \
	E74B06A0454F6E92400A3450FD1FF09C03824582 \
	03CC5FFA61AAAD3C8FF25E9270F09CC6B876884A \
	2C72EB1397733A551DDB60CCF119941F6E68DA61 \
	66619BA3C030DD5536251303817AE1DD322D7ECA \
	50BE56C1086BF13AE96246F76C5A4F6DECA39416 \
	0186F8B24C5BC02C94A0E0E486F75E83E1EE085F \
	A9444FB7DB71EFE47A9FCF0F88E27CA20ED7633F \
	90FDA7F91FF114EAA990D6BD4022EC8987DB5B64 \
	5F55943E13D49059D3F342777186B06E1ED139E7 \
	770EC46CB27DD2BE15F549D999B679DEB38493BF \
	3558857D1F5754B78C7F8B5A71A45A3D0D8D0B93

ENV SOLR_VERSION 4.10.2
ENV SOLR_TGZ_URL https://www.apache.org/dist/lucene/solr/$SOLR_VERSION/solr-$SOLR_VERSION.tgz

RUN NEAREST_SOLR_TGZ_URL=$(curl -sSL http://www.apache.org/dyn/closer.cgi/${SOLR_TGZ_URL#https://www.apache.org/dist/}\?asjson\=1 \
		| awk '/"path_info": / { pi=$2; }; /"preferred":/ { pref=$2; }; END { print pref " " pi; };' \
		| sed -r -e 's/^"//; s/",$//; s/" "//') \
	&& sed -i 's/8080/8983/' /opt/tomcat/conf/server.xml \
	&& mkdir -p /opt/solr/{data,conf,lib} \
	&& echo "Nearest mirror: $NEAREST_SOLR_TGZ_URL" \
	&& curl -sSL $NEAREST_SOLR_TGZ_URL -o solr.tar.gz \
	&& curl -sSL $SOLR_TGZ_URL.asc -o solr.tar.gz.asc \
	&& gpg --verify solr.tar.gz.asc \
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

