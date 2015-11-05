FROM kolab/base-asav:latest

ADD /Nulecule /Dockerfile /application-entity/
ADD /artifacts /application-entity/artifacts/

ENV KOLAB_ROLE ASAV_IN

ADD /entrypoint.sh /entrypoint.sh
RUN chmod a+x /entrypoint.sh
