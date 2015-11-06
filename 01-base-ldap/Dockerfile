FROM kolab/base:latest

RUN yum -y --setopt tsflags= install kolab-schema && \
    yum -y install kolab-ldap

RUN cp /usr/share/doc/kolab-schema-*/*.ldif \
    /etc/dirsrv/schema/99kolab3.ldif && \
    chown nobody:nobody /etc/dirsrv/schema/99kolab3.ldif && \
    chmod 600 /etc/dirsrv/schema/99kolab3.ldif

EXPOSE 389 636
