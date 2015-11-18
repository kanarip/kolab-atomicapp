FROM projectatomic/mariadb-centos7-atomicapp

RUN sed -i \
    -e 's/name: mariadb/name: webadmin-database/g' \
    /application-entity/artifacts/kubernetes/*.yaml
