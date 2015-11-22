FROM kolab/base:latest

RUN yum -y install \
        cyrus-imapd \
        kolab-saslauthd && \
    yum clean all

EXPOSE 110 143 993 995 4190

CMD [ \
        "/usr/lib/cyrus-imapd/cyrus-master", \
        "-L", \
        "/dev/null" \
    ]
