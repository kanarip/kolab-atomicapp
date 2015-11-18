FROM projectatomic/mariadb-centos7-atomicapp

RUN sed -i \
    -e 's/name: mariadb/name: irony-database/g' \
    /application-entity/artifacts/kubernetes/*.yaml
