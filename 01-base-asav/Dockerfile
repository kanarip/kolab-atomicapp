FROM kolab/base:latest

RUN yum -y install \
        amavisd-new \
        clamav && \
    yum clean all

VOLUME [ "/var/spool/amavisd" ]

EXPOSE 10024

ADD /entrypoint.sh /entrypoint.sh
RUN chmod a+x /entrypoint.sh

CMD [ \
        "/usr/sbin/amavisd", \
        "-u", "amavis", \
        "-g", "amavis", \
        "-c", "/etc/amavisd/amavisd.conf", \
        "foreground" \
    ]

