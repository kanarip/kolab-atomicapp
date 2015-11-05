FROM kolab/base-imap:latest

ADD /Nulecule /Dockerfile /application-entity/
ADD /artifacts /application-entity/artifacts/

VOLUME [ "/data" ]

ADD /entrypoint.sh /entrypoint.sh
RUN chmod a+x /entrypoint.sh

