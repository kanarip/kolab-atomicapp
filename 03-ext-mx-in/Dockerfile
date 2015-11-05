FROM kolab/base-mx:latest

ADD /Nulecule /Dockerfile /application-entity/
ADD /artifacts /application-entity/artifacts/

VOLUME [ "/var/spool/postfix" ]

ADD entrypoint.sh /entrypoint.sh

CMD [ "/usr/libexec/postfix/master", "-D" ]

