FROM kolab/base:latest

RUN yum -y install wallace

ADD /Nulecule /Dockerfile /application-entity/
ADD /artifacts /application-entity/artifacts/

EXPOSE 10026

VOLUME [ "/var/spool/pykolab/wallace" ]
