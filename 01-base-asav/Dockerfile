FROM kolab/base:latest

RUN yum -y install amavisd-new clamav

ADD clamd@.service /etc/systemd/system/clamd@.service

RUN yum -y reinstall systemd; systemctl daemon-reload; systemctl enable clamd@amavisd.service

VOLUME [ "/var/spool/amavisd" ]

EXPOSE 10024

ADD entrypoint.sh /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]

CMD [ "/usr/sbin/amavisd", "-u", "amavis", "-g", "amavis", "foreground" ]

