FROM kolab/base-mx:latest

VOLUME [ "/var/spool/postfix" ]

EXPOSE 25 10025

ADD /entrypoint.sh /entrypoint.sh
RUN chmod a+x /entrypoint.sh

CMD [ "/usr/libexec/postfix/master", "-D" ]

