FROM kolab/base:latest

RUN yum -y install \
        erlang-erts \
        erlang-rebar \
        git \
        make && \
    yum clean all

RUN git clone https://git.kolab.org/diffusion/G/guam.git /root/guam.git
WORKDIR /root/guam.git/

RUN timeout 60s rebar get-deps
RUN timeout 60s rebar compile
RUN timeout 60s rebar eunit

WORKDIR /root/guam.git/rel/

RUN timeout 60s rebar generate

WORKDIR /root/guam.git/

ADD /entrypoint.sh /entrypoint.sh
RUN chmod a+x /entrypoint.sh

ADD /sys.config /root/guam.git/rel/kolab_guam/releases/0.1/sys.config

EXPOSE 143 993

CMD [ \
        "rel/kolab_guam/bin/kolab_guam", \
        "foreground" \
    ]
