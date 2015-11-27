FROM kolab/base:latest

ENV NODE_VERSION=0.12.8

RUN yum -y install \
        bzip2 \
        gcc-c++ \
        git \
        libjpeg-turbo-utils \
        libpng-devel \
        make \
        tar \
        wget && \
    yum clean all

RUN cd /tmp && \
    wget http://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}.tar.gz && \
    tar zxvf node-v${NODE_VERSION}.tar.gz && \
    rm -f node-v${NODE_VERSION}.tar.gz && \
    cd node-v${NODE_VERSION}/ && \
    ./configure --prefix=/usr && \
    CXX="g++ -Wno-unused-local-typedefs" make && \
    CXX="g++ -Wno-unused-local-typedefs" make install && \
    cd /tmp && \
    rm -rf /tmp/node-v* && \
    npm config set registry http://registry.npmjs.org/ && \
    npm install -g bower ember-cli npm && \
    rm -rf /root/.npm/ && \
    printf '\n# Node.js\nexport PATH="node_modules/.bin:$PATH"' >> /root/.bashrc

RUN npm config set registry http://registry.npmjs.org/

RUN npm update -g \
        node-gyp \
        npm && \
    rm -rf /root/.npm/

RUN npm install -g \
        bower && \
    rm -rf /root/.npm/
