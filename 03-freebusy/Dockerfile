FROM kolab/base-web-rc:latest

RUN yum -y install \
        kolab-freebusy && \
    yum clean all

ADD /entrypoint.sh /entrypoint.sh
RUN chmod a+x /entrypoint.sh
