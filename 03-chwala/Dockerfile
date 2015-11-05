FROM kolab/base-web-rc:latest

RUN yum -y install \
    chwala

ADD /Nulecule /Dockerfile /application-entity/
ADD /artifacts /application-entity/artifacts/

EXPOSE 80 443
