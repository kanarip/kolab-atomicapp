FROM kolab/base-web
MAINTAINER Kolab Systems <vanmeeuwen@kolabsys.com>
RUN yum -y install kolab-webclient

ADD /Nulecule /Dockerfile /application-entity/
ADD /artifacts /application-entity/artifacts/

ADD httpd.service /etc/systemd/system/httpd.service

EXPOSE 80 443

ADD entrypoint.sh /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]

CMD [ "/usr/lib/cyrus-imapd/cyrus-master", "-D" ]

