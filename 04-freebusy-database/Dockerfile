FROM projectatomic/mariadb-centos7-atomicapp

RUN sed -i \
    -e 's/name: mariadb/name: freebusy-database/g' \
    /application-entity/artifacts/kubernetes/*.yaml

RUN sed -i \
    -e 's/id: mariadb-/id: freebusy-database-/g' \
    /application-entity/Nulecule
