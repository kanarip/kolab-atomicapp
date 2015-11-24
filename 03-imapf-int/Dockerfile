FROM kolab/base-imap:latest

ADD /entrypoint.sh /entrypoint.sh
RUN chmod a+x /entrypoint.sh

ADD /cyrus.conf.tpl /etc/kolab/templates/cyrus.conf.tpl
ADD /imapd.conf.tpl /etc/kolab/templates/imapd.conf.tpl
