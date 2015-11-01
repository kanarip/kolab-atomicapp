FROM kolab/base:latest

RUN yum -y install \
    kolab-ldap

VOLUME [ \
        "/etc/dirsrv", \
        "/var/lib/dirsrv" \
    ]

EXPOSE 389 636 9830
