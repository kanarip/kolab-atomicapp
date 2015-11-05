FROM kolab/base-mx:latest

RUN yum -y install \
    kolab-saslauthd

EXPOSE 587

ADD /entrypoint.sh /entrypoint.sh
RUN chmod a+x /entrypoint.sh
