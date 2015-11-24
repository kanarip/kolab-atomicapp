FROM docker.io/library/centos:centos7
MAINTAINER Jeroen van Meeuwen (Kolab Systems) <vanmeeuwen@kolabsys.com>

RUN yum -y install epel-release && \
    yum -y install \
        @fedora-packager \
        gcc \
        git \
        libuuid-devel \
        net-tools \
        nginx \
        perl-AnyEvent-HTTP \
        perl-Archive-Tar \
        perl-CPAN \
        perl-CPAN-Meta \
        perl-CPAN-Meta-Requirements \
        perl-CPAN-Meta-YAML \
        perl-Data-UUID \
        perl-DateTime \
        perl-DBD-SQLite \
        perl-DBI \
        perl-Email-Address \
        perl-Email-MIME \
        perl-ExtUtils-CBuilder \
        perl-ExtUtils-MakeMaker \
        perl-HTML-Parser \
        perl-HTML-Strip \
        perl-HTTP-Tiny \
        perl-Image-Size \
        perl-IO-Socket-SSL \
        perl-JSON \
        perl-JSON-PP \
        perl-JSON-XS \
        perl-Locale-Maketext-Gettext \
        perl-Object-Event \
        perl-Parse-CPAN-Meta \
        perl-Switch \
        screen \
        vim-enhanced

RUN ( sleep 1; \
        echo "yes"; \
    ) | perl -MCPAN -e shell || :

ADD bashrc /root/.bashrc

WORKDIR /srv/
RUN git clone https://github.com/jmapio/jmap-perl.git jmap-perl.git
WORKDIR /srv/jmap-perl.git
RUN echo notest install $(grep -r "^use " bin/ Email/ JMAP/ Mail/ AnyEvent/ | awk '{print $2}' | sed -re 's/;$//g' | sort -u | grep -vE "(base|constant|lib|strict|warnings)") | perl -MCPAN -e shell || :

RUN ( echo "notest install CPAN" ) | perl -MCPAN -e shell
RUN ( echo "notest install List::Pairwise" ) | perl -MCPAN -e shell

WORKDIR /srv/
RUN git clone https://github.com/CindyLinz/Perl-AnyEvent-HTTPD-SendMultiHeaderPatch.git Perl-AnyEvent-HTTPD-SendMultiHeaderPatch.git
WORKDIR /srv/Perl-AnyEvent-HTTPD-SendMultiHeaderPatch.git
RUN perl Makefile.PL && \
    make && \
    make install

WORKDIR /srv/
RUN git clone https://github.com/fastmail/Net-CardDAVTalk.git Net-CardDAVTalk.git
WORKDIR /srv/Net-CardDAVTalk.git
RUN perl Makefile.PL && \
    make && \
    make install

WORKDIR /srv/jmap-perl.git
RUN echo notest install $(grep -r "^use " bin/ Email/ JMAP/ Mail/ AnyEvent/ | awk '{print $2}' | sed -re 's/;$//g' | sort -u | grep -vE "(base|constant|lib|strict|warnings)") | perl -MCPAN -e shell || :

ADD nginx.conf /etc/nginx/nginx.conf

ADD http://cgit.kolab.org/docker/plain/ci/files.d/dbus.service /etc/systemd/system/dbus.service
RUN ln -sf dbus.service /etc/systemd/system/messagebus.service

ADD http://cgit.kolab.org/docker/plain/ci/files.d/httpd.service /etc/systemd/system/httpd.service

ADD http://cgit.kolab.org/docker/plain/ci/files.d/systemctl /usr/bin/systemctl
ADD http://cgit.kolab.org/docker/plain/ci/files.d/systemctl-socket-daemon /usr/bin/systemctl-socket-daemon

RUN chmod -v a+rx \
    /usr/bin/systemctl \
    /usr/bin/systemctl-socket-daemon

WORKDIR /root/
RUN mkdir -p /home/jmap/data/ && ln -s /srv/jmap-perl.git/ /home/jmap/jmap-perl

RUN sed -i -e 's/https:/http:/g' /srv/jmap-perl.git/bin/server.pl

RUN rm -rf \
    /srv/Perl-AnyEvent-HTTPD-SendMultiHeaderPatch.git \
    /srv/Net-CardDAVTalk.git \
    /root/.cpan

EXPOSE 80

ENV jmaphost 172.17.42.1

ADD entrypoint.sh /root/entrypoint.sh
RUN chmod 755 /root/entrypoint.sh
ENTRYPOINT /root/entrypoint.sh
