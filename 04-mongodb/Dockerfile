FROM centos:centos7

MAINTAINER Jeroen van Meeuwen <vanmeeuwen@kolabsys.com>

RUN yum clean all && \
    yum -y install epel-release && \
    yum -y install mongodb-server && \
    yum clean all

RUN sed -r -i \
    -e '/^bind_ip/d' \
    -e '/^fork/d' \
    /etc/mongod.conf

VOLUME /var/lib/mongodb

EXPOSE 27017

ADD /entrypoint.sh /entrypoint.sh

RUN chmod a+x /entrypoint.sh

USER mongodb

ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "mongod", "--quiet", "-f", "/etc/mongod.conf" ]
