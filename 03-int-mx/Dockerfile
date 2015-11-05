FROM kolab/base-mx:latest

ADD /Nulecule /Dockerfile /application-entity/
ADD /artifacts /application-entity/artifacts/

VOLUME [ "/var/spool/postfix" ]

EXPOSE 25 587

ADD /entrypoint.sh /entrypoint.sh
RUN chmod a+x /entrypoint.sh

CMD [ "/usr/libexec/postfix/master", "-D" ]
