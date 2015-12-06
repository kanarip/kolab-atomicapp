FROM kolab/base:latest

RUN yum -y install \
        httpd \
        php \
        mod_ssl && \
    yum clean all

RUN sed -r -i \
    -e 's|^(\s*)CustomLog .* common$|\1CustomLog /proc/self/fd/1 common|g' \
    -e 's|^(\s*)ErrorLog .*$|\1ErrorLog /proc/self/fd/2|g' \
    /etc/httpd/conf/httpd.conf

EXPOSE 80 443

CMD [ "/usr/sbin/httpd" , "-DFOREGROUND" ]
