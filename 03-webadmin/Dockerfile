FROM kolab/base-web-rc:latest

RUN yum -y --setopt tsflags= install \
        kolab-webadmin && \
    yum -y install \
        mariadb \
        pykolab && \
    yum clean all

ADD /entrypoint.sh /entrypoint.sh
RUN chmod a+x /entrypoint.sh
