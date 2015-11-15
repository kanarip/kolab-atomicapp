FROM kolab/base-ldap:latest

ADD /entrypoint.sh /entrypoint.sh
RUN chmod a+x /entrypoint.sh

CMD [ \
        "/usr/sbin/ns-slapd", \
        "-D", \
        "/data/etc/dirsrv/slapd-ldap", \
        "-i", \
        "/var/run/dirsrv/slapd-ldap.pid", \
        "-w /var/run/dirsrv/slapd-ldap.startpid" \
    ]
