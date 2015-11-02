FROM kolab/base:latest

RUN yum -y install \
    cyrus-imapd \
    kolab-saslauthd

EXPOSE 110 143 993 995 4190

USER cyrus

ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/usr/lib/cyrus-imapd/cyrus-master", "-D" ]
