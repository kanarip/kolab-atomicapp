FROM kolab/base-mx:latest

RUN yum -y install \
    kolab-saslauthd

ADD /Nulecule /Dockerfile /application-entity/
ADD /artifacts /application-entity/artifacts/

EXPOSE 587
