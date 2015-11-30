FROM centos:centos7

MAINTAINER Jeroen van Meeuwen <vanmeeuwen@kolabsys.com>

# This should really be a part of the base image.
RUN rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7

# To speed things up, disable fastestmirror.
RUN sed -r -i \
        -e 's/^enabled.*$/enabled = 0/g' \
        /etc/yum/pluginconf.d/fastestmirror.conf

# Add EPEL.
RUN yum -y install epel-release && \
    yum clean all

# Add the EPEL key.
RUN rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-7

# Add the Kolab:Development repository.
ADD http://obs.kolabsys.com/repositories/Kolab:/Development/CentOS_7/Kolab:Development.repo \
    /etc/yum.repos.d/Kolab:Development.repo

# Give the Kolab:Development repository priority over everything else.
RUN echo "priority=60" >> /etc/yum.repos.d/Kolab:Development.repo

# Add the Kolab:Development key.
RUN rpm --import https://ssl.kolabsys.com/community.asc

# Make YUM obey priorities configured.
RUN yum -y install yum-plugin-priorities && \
    yum clean all

# Install some debugging utilities.
RUN yum -y install \
        bind-utils \
        cyrus-imapd \
        lsof \
        net-tools \
        nmap-ncat \
        openldap-clients \
        psmisc \
        strace \
        telnet \
        traceroute \
        vim-enhanced && \
    yum clean all

ADD /functions.sh /functions.sh
ADD /entrypoint.sh /entrypoint.sh
RUN chmod a+x /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]
