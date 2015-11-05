FROM kolab/base:latest

RUN yum -y install amavisd-new clamav

VOLUME [ "/var/spool/amavisd" ]

EXPOSE 10024

ADD entrypoint.sh /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]

CMD [ \
        "/usr/sbin/amavisd", \
        "-u", "amavis", \
        "-g", "amavis", \
        "-c", "/etc/amavisd/amavisd.conf", \
        "foreground"
    ]

