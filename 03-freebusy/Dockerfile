FROM kolab/base-web-rc:latest

RUN yum -y install \
        kolab-freebusy && \
    yum clean all

EXPOSE 80 443

ADD /entrypoint.sh /entrypoint.sh
RUN chmod a+x /entrypoint.sh
