FROM kolab/base-mx:latest

RUN yum -y install amavisd-new clamav

ADD clamd@.service /etc/systemd/system/clamd@.service

ADD entrypoint /entrypoint.sh

VOLUME [ "/var/spool/amavisd" ]

