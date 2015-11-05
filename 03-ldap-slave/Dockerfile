FROM kolab/base-ldap:latest

ADD /Nulecule /Dockerfile /application-entity/
ADD /artifacts /application-entity/artifacts/

ADD /entrypoint.sh /entrypoint.sh
RUN chmod a+x /entrypoint.sh
