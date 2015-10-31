FROM projectatomic/atomicapp:0.1.12

MAINTAINER Kolab Systems <contact@kolabsys.com>

LABEL io.projectatomic.nulecule.providers="kubernetes" \
      io.projectatomic.nulecule.specversion="0.0.2"

ADD http://obs.kolabsys.com/repositories/Kolab:/Development/CentOS_7/Kolab:Development.repo \
    /etc/yum.repos.d/Kolab:Development.repo

RUN sed -i -r -e 's|https://dl.fedoraproject.org/pub/epel|http://mirror.switch.ch/ftp/mirror/epel|g' /etc/yum.repos.d/epel*.repo

ADD dbus.service /etc/systemd/system/dbus.service
RUN ln -sf dbus.service /etc/systemd/system/messagebus.service

ADD systemctl /usr/bin/systemctl
ADD systemctl-socket-daemon /usr/bin/systemctl-socket-daemon

RUN rpm --import https://ssl.kolabsys.com/community.asc && \
        echo "priority=60" >> /etc/yum.repos.d/Kolab:Development.repo && \
        yum -y install epel-release && \
        yum -y install yum-plugin-priorities && \
        yum -y install perl-Data-Dumper && \
        yum clean all && \
        yum -y update && \
        yum clean all
