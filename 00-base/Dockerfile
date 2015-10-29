FROM projectatomic/atomicapp:0.1.12

MAINTAINER Kolab Systems <contact@kolabsys.com>

LABEL io.projectatomic.nulecule.providers="kubernetes" \
      io.projectatomic.nulecule.specversion="0.0.2"

ADD http://obs.kolabsys.com/repositories/Kolab:/Development/CentOS_7/Kolab:Development.repo \
    /etc/yum.repos.d/Kolab:Development.repo

RUN rpm --import https://ssl.kolabsys.com/community.asc && \
        echo "priority=60" >> /etc/yum.repos.d/Kolab:Development.repo && \
        yum -y install epel-release && \
        yum -y install yum-plugin-priorities && \
        yum clean all && \
        yum -y update && \
        yum clean all
