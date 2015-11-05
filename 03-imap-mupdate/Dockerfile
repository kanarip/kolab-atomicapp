FROM kolab/base:latest

RUN yum -y install \
    cyrus-imapd \
    kolab-saslauthd

ADD /Nulecule /Dockerfile /application-entity/
ADD /artifacts /application-entity/artifacts/

USER cyrus

ADD entrypoint.sh /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]

CMD [ "/usr/lib/cyrus-imapd/cyrus-master", "-D" ]

