FROM kolab/base:latest

RUN yum -y install \
    httpd \
    php \
    mod_ssl

ENTRYPOINT [ "/usr/sbin/httpd" , "-DFOREGROUND" ]

EXPOSE 80 443

