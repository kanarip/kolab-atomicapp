FROM kolab/base-mx:latest

EXPOSE 25 587

ADD /entrypoint.sh /entrypoint.sh
RUN chmod a+x /entrypoint.sh

CMD [ "/usr/libexec/postfix/master", "-D" ]
