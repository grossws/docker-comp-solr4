# Info

Solr4 basic [Dockerfiles][df] for automated builds on [docker hub][dhub].

Based on `grossws/tomcat8` image.

Is part of the [docker-components][dcomp] repo.

[df]: http://docs.docker.com/reference/builder/ "Dockerfile reference"
[dhub]: https://hub.docker.com/u/grossws/
[dcomp]: https://github.com/grossws/docker-components


# Licensing

Licensed under MIT License. See [LICENSE file](LICENSE)


# Thirdparty

Contains:
- Apache [Tomcat 8][tomcat], which is licensed under [Apache License, Version 2.0][apl].
  
  Full license can be found in `/opt/tomcat/LICENSE` in container.
  It's components licensing info can be found in `/opt/tomcat/NOTICE` in container.

- Apache [Solr 4][solr], licensed under [Apache License, Version 2.0][apl] and its dependencies.

  Full Solr license can be found in `/opt/solr/LICENSE` in container.
  It's components licensing info can be found in `/opt/solr/NOTICE` in container.

- Apache [log4j library][log4j], licensed under [Apache License][apl].

- [slf4j library][slf4j], licensed under [MIT License][slf4j-lic].


[apl]: http://www.apache.org/licenses/LICENSE-2.0
[tomcat]: http://tomcat.apache.org/
[solr]: http://lucene.apache.org/solr/
[log4j]: http://logging.apache.org/log4j/1.2/
[slf4j]: http://slf4j.org/
[slf4j-lic]: http://slf4j.org/license.html

