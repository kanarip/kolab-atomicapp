FROM kolab/base-mx:latest

RUN yum -y install \
        kolab-saslauthd && \
    yum clean all

ADD /Nulecule /Dockerfile /application-entity/
ADD /artifacts /application-entity/artifacts/

EXPOSE 587
