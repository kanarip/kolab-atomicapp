FROM kolab/base-web-rc:latest

RUN yum -y install \
        roundcubemail \
        roundcubemail-plugin-contextmenu \
        roundcubemail-plugins-kolab && \
    yum clean all

EXPOSE 80 443
