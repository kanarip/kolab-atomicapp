FROM kolab/base:latest

RUN yum -y install \
    kolab-mta

ADD /Nulecule /Dockerfile /application-entity/
ADD /artifacts /application-entity/artifacts/

VOLUME [ "/var/spool/postfix", "/var/spool/pykolab" ]

ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]

CMD [ "/usr/libexec/postfix/master", "-D" ]

