FROM centos:centos7

MAINTAINER Jeroen van Meeuwen <vanmeeuwen@kolabsys.com>

ADD http://obs.kolabsys.com/repositories/Kolab:/Development/CentOS_7/Kolab:Development.repo \
    /etc/yum.repos.d/Kolab:Development.repo

RUN rpm --import https://ssl.kolabsys.com/community.asc && \
    echo "priority=60" >> /etc/yum.repos.d/Kolab:Development.repo && \
    yum -y install epel-release && \
    yum -y install yum-plugin-priorities && \
    yum -y install \
        bind-utils \
        net-tools \
        openldap-clients \
        strace \
        telnet \
        traceroute && \
    yum clean all

ADD /entrypoint.sh /entrypoint.sh
RUN chmod a+x /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]
