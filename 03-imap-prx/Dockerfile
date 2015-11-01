FROM kolab/base:latest

RUN yum -y install \
    cyrus-imapd \
    kolab-saslauthd

ADD /Nulecule /Dockerfile /application-entity/
ADD /artifacts /application-entity/artifacts/

ADD entrypoint.sh /entrypoint.sh

ENTRYPOINT /entrypoint.sh

CMD [ "/usr/sbin/guam", "-D" ]
