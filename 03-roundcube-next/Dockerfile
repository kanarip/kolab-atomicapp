#FROM kolab/base-nodejs:latest
FROM kolab/base:latest

MAINTAINER Jeroen van Meeuwen (Kolab Systems) <vanmeeuwen@kolabsys.com>

ENV NODE_VERSION=0.12.8

RUN yum -y install \
        gcc-c++ \
        git \
        make \
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

RUN yum -y install \
        ruby-devel \
        rubygem-bundler && \
    yum clean all

RUN git clone \
        https://github.com/roundcube-next/roundcube-shell.git \
        /var/www/roundcube-shell.git/ && \
    rm -rf /var/www/roundcube-shell.git/.git/

RUN git clone \
        https://github.com/roundcube-next/roundcube-mail.git \
        /var/www/roundcube-mail.git/ && \
    rm -rf /var/www/roundcube-mail.git/.git/

RUN git clone \
        https://github.com/roundcube-next/roundcube-notifications.git \
        /var/www/roundcube-notifications.git/ && \
    rm -rf /var/www/roundcube-notifications.git/.git/

WORKDIR /var/www/roundcube-mail.git/
#RUN npm install && \
#    rm -rf /root/.npm/ && \
#    npm link
RUN npm link

WORKDIR /var/www/roundcube-notifications.git/
#RUN npm install && \
#    rm -rf /root/.npm/ && \
#    npm link
RUN npm link

WORKDIR /var/www/roundcube-shell.git/
RUN npm link roundcube-mail
RUN npm link roundcube-notifications
RUN bundle
RUN sed -r -i \
    -e 's/"ember-try":(.*),$/"ember-try":\1/g' \
    -e '/roundcube-mail/d' \
    -e '/roundcube-notifications/d' \
    package.json

RUN npm install && \
    rm -rf /root/.npm/

RUN bower --allow-root install

ENV NODE_PATH /usr/lib/node_modules:/var/www/roundcube-shell.git/node_modules
ENV NODE_ENV production

# These fail, see https://git.kolab.org/T858
RUN ember build --environment production
#RUN ember build

ADD /entrypoint.sh /entrypoint.sh
RUN chmod a+x /entrypoint.sh

CMD [ \
        "ember", \
        "server" \
    ]
