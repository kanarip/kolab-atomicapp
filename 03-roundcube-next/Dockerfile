FROM kolab/base-nodejs:latest

MAINTAINER Jeroen van Meeuwen (Kolab Systems) <vanmeeuwen@kolabsys.com>

#ENV GITHUB_ACCOUNT=kanarip
#ENV GIT_BRANCH=dev/ember-build-fails

RUN yum -y install \
        ruby-devel \
        rubygem-bundler && \
    yum clean all

RUN npm install --verbose -g \
        ember-cli && \
    rm -rf /root/.npm/

RUN git clone \
        -b ${GIT_BRANCH:-master} \
        https://github.com/${GITHUB_ACCOUNT:-roundcube-next}/roundcube-shell.git \
        /var/www/roundcube-shell.git/ && \
    rm -rf /var/www/roundcube-shell.git/.git/

WORKDIR /var/www/roundcube-shell.git/

RUN npm install --verbose && \
    rm -rf /root/.npm/

RUN bower --allow-root install

# These fail, see https://git.kolab.org/T858
RUN sed -i \
    -e '/ES6 only/,+19d' \
    node_modules/jscs/lib/config/configuration.js

RUN ember build --environment production

ADD /entrypoint.sh /entrypoint.sh
RUN chmod a+x /entrypoint.sh

CMD [ \
        "ember", \
        "server", \
        "--live-reload=false" \
    ]
