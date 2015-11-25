FROM kolab/base-nodejs:latest

MAINTAINER Jeroen van Meeuwen (Kolab Systems) <vanmeeuwen@kolabsys.com>

RUN npm install -g \
        grunt-cli \
        phantomjs && \
    rm -rf /root/.npm/

WORKDIR /var/www/
RUN git clone https://git.kolab.org/diffusion/M/manticore.git /var/www/manticore.git/

WORKDIR /var/www/manticore.git/
RUN npm install && \
    npm dedupe && \
    rm -rf /root/.npm/

RUN bower install --allow-root
RUN grunt build

RUN mv server/config/local.env.sample.js server/config/local.env.js
RUN sed -r -i \
    -e "s|DOMAIN:.*,$|DOMAIN: 'http://localhost:8080',|g" \
    -e "s|STORAGE:.*$|STORAGE: 'local'|g" \
    -e "/WEBDAV_/d" \
    -e "/LDAP_/d" \
    -e "/LOCODOC_/d" \
    server/config/local.env.js

RUN sed -r -i \
    -e 's|^(\s+)root:.*,$|\1root: "/var/www/manticore.git",|g' \
    server/config/environment/index.js

RUN chown nobody:nobody \
    /var/www/manticore.git/server/config/seed.js \
    /var/www/manticore.git/server/config/

RUN ln -s dist/public/ public

ADD /entrypoint.sh /entrypoint.sh
RUN chmod a+x /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]

USER nobody

ENV NODE_PATH /usr/lib/node_modules:/var/www/manticore.git/node_modules
ENV NODE_ENV production

CMD [ "/bin/node", "/var/www/manticore.git/server/app.js" ]
