FROM kolab/base-web:latest

RUN yum -y install \
        libcalendaring \
        libkolab \
        libkolabxml \
        php-kolab \
        php-kolabformat && \
    yum -y --setopts tsflags= install \
        roundcubemail-core && \
    yum -y install \
        roundcubemail
