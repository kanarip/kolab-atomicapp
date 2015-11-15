FROM kolab/base:latest

RUN yum -y install \
        wallace && \
    yum clean all

VOLUME [ "/var/spool/pykolab/wallace" ]

EXPOSE 10026
