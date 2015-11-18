FROM kolab/base:latest

RUN yum -y --setopt tsflags= install \
        kolab-schema && \
    yum -y install \
        kolab-ldap \
        net-tools && \
    yum clean all

RUN cp /usr/share/doc/kolab-schema-*/*.ldif \
    /etc/dirsrv/schema/99kolab3.ldif && \
    chown root:root /etc/dirsrv/schema/99kolab3.ldif && \
    chmod 644 /etc/dirsrv/schema/99kolab3.ldif

ADD /template.ldif /usr/share/dirsrv/data/template.ldif

RUN mkdir -p /run/lock
RUN ln -sf /bin/true /sbin/semanage
RUN ln -sf /bin/true bin/systemctl

VOLUME [ "/data" ]

EXPOSE 389 636
