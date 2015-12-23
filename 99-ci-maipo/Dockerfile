FROM centos:centos7
MAINTAINER Kolab Systems <vanmeeuwen@kolabsys.com>

ADD http://obs.kolabsys.com/repositories/Kolab:/Development/CentOS_7/Kolab:Development.repo \
    /etc/yum.repos.d/Kolab:Development.repo

ADD http://obs.kolabsys.com/repositories/Kolab:/3.4/CentOS_7/Kolab:3.4.repo \
    /etc/yum.repos.d/Kolab:3.4.repo

ADD http://obs.kolabsys.com/repositories/Kolab:/3.4:/Updates/CentOS_7/Kolab:3.4:Updates.repo \
    /etc/yum.repos.d/Kolab:3.4:Updates.repo

RUN echo "priority=60" >> /etc/yum.repos.d/Kolab:Development.repo

RUN echo "priority=60" >> /etc/yum.repos.d/Kolab:3.4.repo

RUN echo "priority=60" >> /etc/yum.repos.d/Kolab:3.4:Updates.repo

RUN rpm --import https://ssl.kolabsys.com/community.asc

ADD http://download.opensuse.org/repositories/openSUSE:Tools/CentOS_7/openSUSE:Tools.repo \
    /etc/yum.repos.d/openSUSE:Tools.repo

RUN rpm --import http://download.opensuse.org/repositories/openSUSE:/Tools/CentOS_7/repodata/repomd.xml.key

RUN sed -i -e '/tsflags=nodocs/d' /etc/yum.conf && \
    sed -r -i -e 's/enabled\s*=\s*1/enabled=0/g' /etc/yum/pluginconf.d/fastestmirror.conf

#RUN yum -y reinstall \*

ENV IMAGE maipo

ADD /dbus.service /etc/systemd/system/dbus.service
RUN ln -sf dbus.service /etc/systemd/system/messagebus.service

ADD /httpd.service /etc/systemd/system/httpd.service

ADD /systemctl /usr/bin/systemctl
ADD /systemctl-socket-daemon /usr/bin/systemctl-socket-daemon

RUN chmod -v a+rx \
    /usr/bin/systemctl \
    /usr/bin/systemctl-socket-daemon

ADD /vimrc /root/.vimrc

RUN yum clean all && \
    yum -y install epel-release && \
    sed -i \
        -e 's/#baseurl/baseurl/g' \
        -e '/^mirrorlist/d' \
        /etc/yum.repos.d/epel*.repo && \
    yum -y install \
        ant \
        bind-utils \
        build \
        git \
        lsof \
        net-tools \
        nmap-ncat \
        openldap-clients \
        osc \
        perl-Data-Dumper \
        perl-Digest-MD5 \
        perl-TimeDate \
        php-phpunit-PHPUnit-Selenium \
        psmisc \
        rpmdevtools \
        screen \
        strace \
        sudo \
        telnet \
        traceroute \
        vim-enhanced \
        yum-utils && \
    yum clean all

RUN sed -i -e '/requiretty/d' /etc/sudoers

WORKDIR /srv
RUN git clone https://github.com/google/closure-compiler.git closure-compiler.git
WORKDIR /srv/closure-compiler.git
RUN ant jar

ADD http://mirror.kolabsys.com/pub/releases/selenium-server-standalone.jar /usr/local/lib/selenium-server-standalone.jar

#WORKDIR /srv
#RUN git clone https://github.com/SeleniumHQ/selenium.git selenium.git
#WORKDIR /srv/selenium.git
#RUN ./go --trace --verbose build
#RUN ./go selenium-server-standalone

ADD http://mirror.kolabsys.com/pub/releases/phantomjs-1.9.7-linux-x86_64.tar.bz2 /srv/
WORKDIR /srv
RUN tar jxvf phantomjs-1.9.7-linux-x86_64.tar.bz2
RUN cp phantomjs-1.9.7-linux-x86_64/bin/phantomjs /usr/local/bin/ && \
    rm -rf phantomjs-1.9.7-linux-x86_64*

#WORKDIR /srv/
#RUN git clone https://github.com/ariya/phantomjs.git phantomjs.git
#WORKDIR /srv/phantomjs.git
#RUN ./build.sh --confirm

ADD /functions.sh /
ADD entrypoint.sh /

RUN chmod 755 /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]
