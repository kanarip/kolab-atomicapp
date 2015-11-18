FROM projectatomic/mariadb-centos7-atomicapp

RUN sed -i \
    -e 's/name: mariadb/name: webadmin-database/g' \
    /application-entity/artifacts/kubernetes/*.yaml

RUN sed -i \
    -e 's/id: mariadb-/id: webadmin-database-/g' \
    /application-entity/Nulecule
