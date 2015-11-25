FROM docker.io/library/centos:centos7

MAINTAINER Jeroen van Meeuwen (Kolab Systems) <vanmeeuwen@kolabsys.com>

RUN yum -y install \
        epel-release && \
    yum -y install \
        git \
        make \
        npm \
        ruby-devel \
        rubygem-bundler && \
    yum clean all

RUN npm install -g \
        bower \
        ember-cli

WORKDIR /var/www/
RUN git clone https://github.com/roundcube-next/roundcube-shell.git roundcube-shell.git
RUN git clone https://github.com/roundcube-next/roundcube-mail.git roundcube-mail.git
RUN git clone https://github.com/roundcube-next/roundcube-notifications.git roundcube-notifications.git

WORKDIR /var/www/roundcube-mail.git/
RUN npm link

WORKDIR /var/www/roundcube-notifications.git/
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

RUN npm install
RUN bower --allow-root install

# These fail, see https://git.kolab.org/T858
#RUN ember build --environment production
#RUN ember build

ADD /entrypoint.sh /entrypoint.sh
RUN chmod a+x /entrypoint.sh

CMD [ \
        "ember", \
        "server" \
    ]
