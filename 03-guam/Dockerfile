FROM kolab/base:latest

ENV GUAM_BRANCH master

RUN yum -y install \
        erlang-eimap \
        erlang-erts \
        erlang-goldrush \
        erlang-lager \
        erlang-rebar \
        make && \
    yum clean all

RUN git clone \
        -b ${GUAM_BRANCH} \
        https://git.kolab.org/diffusion/G/guam.git \
        /root/guam.git

WORKDIR /root/guam.git/

RUN timeout 60s rebar get-deps
RUN timeout 60s rebar compile
RUN timeout 60s rebar eunit
RUN mkdir -p deps

WORKDIR /root/guam.git/rel/

RUN timeout 60s rebar generate

WORKDIR /root/guam.git/

ADD /entrypoint.sh /entrypoint.sh
RUN chmod a+x /entrypoint.sh

RUN mkdir -p \
        /etc/guam/ && \
    mv -v \
        $(ls -1d /root/guam.git/rel/kolab_guam/releases/*/)/sys.config \
        /etc/guam/sys.config && \
    ln -s \
        /etc/guam/sys.config \
        $(ls -1d /root/guam.git/rel/kolab_guam/releases/*/)/.

EXPOSE 143 993

CMD [ \
        "rel/kolab_guam/bin/kolab_guam", \
        "foreground" \
    ]
