FROM kolab/base-web-rc:latest

RUN yum -y install \
    iRony

ADD /Nulecule /Dockerfile /application-entity/
ADD /artifacts /application-entity/artifacts/

EXPOSE 80 443

ADD /entrypoint.sh /entrypoint.sh
RUN chmod a+x /entrypoint.sh
