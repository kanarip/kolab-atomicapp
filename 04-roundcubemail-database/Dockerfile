FROM projectatomic/mariadb-centos7-atomicapp

RUN sed -i \
    -e 's/name: mariadb/name: roundcubemail-database/g' \
    /application-entity/artifacts/kubernetes/*.yaml
