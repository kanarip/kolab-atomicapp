FROM kolab/base:latest

RUN yum -y install \
    httpd \
    php \
    mod_ssl

EXPOSE 80 443

CMD [ "/usr/sbin/httpd" , "-DFOREGROUND" ]
