FROM kolab/base:latest

RUN yum -y install \
        httpd \
        php \
        mod_ssl && \
    yum clean all

EXPOSE 80 443

CMD [ "/usr/sbin/httpd" , "-DFOREGROUND" ]
