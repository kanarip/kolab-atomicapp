FROM kolab/base-ext-mx:latest

RUN yum -y install \
    kolab-mta \
    kolab-saslauthd

ADD /Nulecule /Dockerfile /application-entity/
ADD /artifacts /application-entity/artifacts/

VOLUME [ "/var/spool/postfix", "/var/spool/pykolab" ]

ADD clamd@.service /etc/systemd/system/clamd@.service

ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]

CMD [ "/usr/libexec/postfix/master", "-D" ]

