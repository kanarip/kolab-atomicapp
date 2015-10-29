FROM kolab/base:latest

RUN yum -y install \
    kolab-imap && \
    rm -rf /etc/imapd.conf /etc/cyrus.conf

ADD /Nulecule /Dockerfile /application-entity/
ADD /artifacts /application-entity/artifacts/

VOLUME [ "/var/lib/imap", "/var/spool/imap" ]

ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]

CMD [ "/usr/lib/cyrus-imapd/cyrus-master", "-D" ]

