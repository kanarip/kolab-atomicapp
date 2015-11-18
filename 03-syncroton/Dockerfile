FROM kolab/base-web-rc:latest

RUN yum -y install \
        kolab-syncroton && \
    yum clean all

ADD /entrypoint.sh /entrypoint.sh
RUN chmod a+x /entrypoint.sh
