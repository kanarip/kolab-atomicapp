START {
    # do not delete this entry!
    recover	    cmd="ctl_cyrusdb -r"
}

SERVICES {
    mupdate     cmd="mupdate"       listen=3905                                 prefork=1 babysit=1

    imap        cmd="proxyd"        listen="imap"                               prefork=1
    imaps       cmd="proxyd -s"     listen="imaps"                              prefork=1

    sieve       cmd="timsieved"     listen="managesieve"                        prefork=1

    ptloader    cmd="ptloader"      listen="/data/var/lib/imap/ptclient/ptsock" prefork=1
}

EVENTS {
    # this is required
    checkpoint  cmd="ctl_cyrusdb -c"    period=30

    tlsprune	cmd="tls_prune"         at=0400
}
