FROM kolab/base-web-rc:latest

RUN yum -y install \
        chwala && \
    yum clean all

ADD /Nulecule /Dockerfile /application-entity/
ADD /artifacts /application-entity/artifacts/

EXPOSE 80 443
