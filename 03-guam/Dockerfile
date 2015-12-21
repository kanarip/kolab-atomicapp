FROM kolab/base:latest

RUN yum -y install guam && \
    yum clean all

ADD /entrypoint.sh /entrypoint.sh
RUN chmod a+x /entrypoint.sh

ADD /sys.config /etc/guam/sys.config

EXPOSE 143 993

CMD [ \
        "/usr/sbin/guam", \
        "foreground" \
    ]
