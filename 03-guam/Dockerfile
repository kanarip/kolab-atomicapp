FROM kolab/base:latest

RUN yum -y install \
        erlang-rebar \
        git \
        make && \
    yum clean all

RUN git clone https://git.kolab.org/diffusion/G/guam.git /root/guam.git
WORKDIR /root/guam.git/
RUN make

ADD /entrypoint.sh /entrypoint.sh
RUN chmod a+x /entrypoint.sh

CMD [ \
        "erl", \
        "-pa", \
        "apps/*/ebin", \
        "deps/*/ebin", \
        "-config", \
        "app", \
        "-s", \
        "kolab_guam" \
    ]
