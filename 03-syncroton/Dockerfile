FROM kolab/base-web-rc:latest

RUN yum -y install \
        kolab-syncroton && \
    yum clean all

ADD /Nulecule /Dockerfile /application-entity/
ADD /artifacts /application-entity/artifacts/
