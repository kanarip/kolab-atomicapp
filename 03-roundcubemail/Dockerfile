FROM kolab/base-web-rc:latest

RUN yum -y install \
    roundcubemail \
    roundcubemail-plugin-contextmenu \
    roundcubemail-plugins-kolab 

ADD /Nulecule /Dockerfile /application-entity/
ADD /artifacts /application-entity/artifacts/

EXPOSE 80 443
