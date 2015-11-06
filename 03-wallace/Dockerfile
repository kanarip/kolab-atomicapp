FROM kolab/base:latest

RUN yum -y install \
        wallace && \
    yum clean all

ADD /Nulecule /Dockerfile /application-entity/
ADD /artifacts /application-entity/artifacts/

VOLUME [ "/var/spool/pykolab/wallace" ]

EXPOSE 10026
