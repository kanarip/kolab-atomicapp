FROM kolab/base-web-rc:latest

RUN yum -y install \
    kolab-syncroton

ADD /Nulecule /Dockerfile /application-entity/
ADD /artifacts /application-entity/artifacts/

ADD /entrypoint.sh /entrypoint.sh
RUN chmod a+x /entrypoint.sh
