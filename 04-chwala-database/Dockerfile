FROM projectatomic/mariadb-centos7-atomicapp

RUN sed -i \
    -e 's/name: mariadb/name: chwala-database/g' \
    /application-entity/artifacts/kubernetes/*.yaml

RUN sed -i \
    -e 's/id: mariadb-/id: chwala-database-/g' \
    /application-entity/Nulecule
