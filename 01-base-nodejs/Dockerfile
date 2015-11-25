FROM kolab/base:latest

RUN yum -y install \
        bzip2 \
        git \
        gcc \
        libjpeg-turbo-utils \
        libpng-devel \
        make \
        npm \
        tar && \
    yum clean all

RUN npm config set registry http://registry.npmjs.org/

RUN npm update -g \
        node-gyp \
        npm && \
    rm -rf /root/.npm/

RUN npm install -g \
        bower && \
    rm -rf /root/.npm/
