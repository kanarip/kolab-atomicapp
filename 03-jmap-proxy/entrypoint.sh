#!/bin/bash

cd /srv/jmap-perl.git

screen -Amd -S api bin/apiendpoint.pl
systemctl start nginx

bin/server.pl
