FROM kolab/base:latest

RUN yum -y install wallace

ADD /Nulecule /Dockerfile /application-entity/
ADD /artifacts /application-entity/artifacts/

VOLUME [ "/var/spool/pykolab/wallace" ]

EXPOSE 10026

ADD /entrypoint.sh /entrypoint.sh
RUN chmod a+x /entrypoint.sh
