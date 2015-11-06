FROM kolab/base-web:latest

RUN yum -y install \
        libcalendaring \
        libkolab \
        libkolabxml \
        php-kolab \
        php-kolabformat && \
    yum -y --setopt tsflags= install \
        roundcubemail && \
    yum clean all
