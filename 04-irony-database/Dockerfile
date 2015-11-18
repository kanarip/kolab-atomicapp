FROM projectatomic/mariadb-centos7-atomicapp

RUN sed -i -r \
    -e 's/name: mariadb/name: irony-database/g' \
    /application-entity/artifacts/kubernetes/*.yaml

RUN sed -i -r \
    -e 's/(id|name): mariadb-/\1: irony-database-/g' \
    /application-entity/Nulecule
