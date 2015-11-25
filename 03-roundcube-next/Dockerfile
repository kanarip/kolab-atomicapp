FROM kolab/base-nodejs:latest

MAINTAINER Jeroen van Meeuwen (Kolab Systems) <vanmeeuwen@kolabsys.com>

RUN npm update -g \
        ember-cli && \
    rm -rf /root/.npm/

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
#RUN ember build --environment production
#RUN ember build

ADD /entrypoint.sh /entrypoint.sh
RUN chmod a+x /entrypoint.sh

CMD [ \
        "ember", \
        "server" \
    ]
