FROM kolab/base-imap:latest

RUN yum -y install \
    kolab-imap && \
    rm -rf /etc/imapd.conf /etc/cyrus.conf

ADD /Nulecule /Dockerfile /application-entity/
ADD /artifacts /application-entity/artifacts/

VOLUME [ "/data" ]

ADD entrypoint.sh /entrypoint.sh
