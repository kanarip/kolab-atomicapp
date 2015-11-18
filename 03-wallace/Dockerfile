FROM kolab/base:latest

RUN yum -y install \
        wallace && \
    yum clean all

ADD /entrypoint.sh /entrypoint.sh
RUN chmod a+x /entrypoint.sh

VOLUME [ "/var/spool/pykolab/wallace" ]

EXPOSE 10026

CMD [ \
        "wallaced" \
    ]
