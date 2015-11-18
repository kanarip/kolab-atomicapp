FROM kolab/base-web-rc:latest

RUN yum -y install \
        roundcubemail \
        roundcubemail-plugin-contextmenu \
        roundcubemail-plugins-kolab && \
    yum clean all

ADD /entrypoint.sh /entrypoint.sh
RUN chmod a+x /entrypoint.sh
