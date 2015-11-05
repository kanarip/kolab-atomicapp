========================
Kolab Atomic Application
========================

Image Inheritance
=================

Inherit images to allow a rebuild of an image to be fast, and for the
sake of de-duplication when deploying.

.. graphviz::

    digraph docker {
            splines = true;
            overlab = prism;

            edge [color=gray50, fontname=Calibri, fontsize=11];
            node [shape=record, fontname=Calibri, fontsize=11];

            "projectatomic/atomicapp";

            "kolab/base";
            "kolab/base-imap";
            "kolab/base-ldap";
            "kolab/base-mx";
            "kolab/base-web";
            "kolab/base-web-rc";

            subgraph cluster_imap {
                    color = white;

                    "kolab/imap-prx";
                    "kolab/imapf-ext";
                    "kolab/imapf-int";
                    "kolab/imap-mupdate";
                    "kolab/imapb";
                }

            subgraph cluster_ldap {
                    color = "white";

                    "kolab/ldap-master";
                    "kolab/ldap-slave";
                }

            subgraph cluster_mx {
                    color = white;

                    "kolab/asav";
                    "kolab/ext-mx-in";
                    "kolab/ext-mx-out";
                    "kolab/int-mx";
                    "kolab/submission";
                    "kolab/wallace";
                }

            subgraph cluster_web {
                    color = white;

                    "kolab/chwala";
                    "kolab/freebusy";
                    "kolab/http-prx";
                    "kolab/irony";
                    "kolab/roundcubemail";
                    "kolab/syncroton";
                    "kolab/webadmin";
                }

            "projectatomic/atomicapp" -> "kolab/base" [dir=back];

            "kolab/base" -> "kolab/base-imap" [dir=back];
            "kolab/base" -> "kolab/base-ldap" [dir=back];
            "kolab/base" -> "kolab/base-mx" [dir=back];
            "kolab/base" -> "kolab/base-web" [dir=back];
            "kolab/base" -> "kolab/kolabd" [dir=back];

            "kolab/base-imap" ->
                    "kolab/imap-prx",
                    "kolab/imapf-int",
                    "kolab/imapf-ext",
                    "kolab/imap-mupdate",
                    "kolab/imapb" [dir=back];

            "kolab/base-ldap" ->
                    "kolab/ldap-master",
                    "kolab/ldap-slave" [dir=back];

            "kolab/base-mx" ->
                    "kolab/asav",
                    "kolab/ext-mx-in",
                    "kolab/ext-mx-out",
                    "kolab/int-mx",
                    "kolab/submission",
                    "kolab/wallace" [dir=back];

            "kolab/base-web" ->
                    "kolab/http-prx",
                    "kolab/webadmin",
                    "kolab/base-web-rc" [dir=back];

            "kolab/base-web-rc" ->
                    "kolab/chwala",
                    "kolab/freebusy",
                    "kolab/irony",
                    "kolab/roundcubemail",
                    "kolab/syncroton" [dir=back];
        }

Container Connection Model
==========================

.. graphviz::

    digraph {
            splines = true;
            overlab = prism;

            edge [color=gray50, fontname=Calibri, fontsize=11];
            node [style=filled, shape=record, fontname=Calibri, fontsize=11];

            "External SMTP Servers" [color="#FFEEEE"];
            "User / Client" [color="#FFEEEE"];

            subgraph cluster_db {
                    color = "white";

                    "projectatomic/mariadb-centos7-atomicapp";
                }

            "kolab/kolabd";

            subgraph cluster_imap {
                    color = white;

                    "kolab/imap-prx";
                    "kolab/imapf-ext";
                    "kolab/imapf-int";
                    "kolab/imap-mupdate";
                    "kolab/imapb";
                }

            subgraph cluster_ldap {
                    color = white;

                    "kolab/ldap-master";
                    "kolab/ldap-slave";
                }

            subgraph cluster_mx {
                    color = white;

                    "kolab/asav";
                    "kolab/ext-mx-in";
                    "kolab/ext-mx-out";
                    "kolab/int-mx";
                    "kolab/submission";
                    "kolab/wallace";
                }

            subgraph cluster_web {
                    color = white;

                    "kolab/chwala";
                    "kolab/freebusy";
                    "kolab/http-prx";
                    "kolab/irony";
                    "kolab/roundcubemail";
                    "kolab/syncroton";
                    "kolab/webadmin";
                }

            "kolab/asav" -> "kolab/ext-mx-in"           [label="(1)"];
            "kolab/asav" -> "kolab/ext-mx-out"          [label="(2)"];

            "kolab/chwala" -> "kolab/imapf-int"         [label="(61)"];
            "kolab/chwala" -> "kolab/ldap-slave"        [label="(62)"];
            "kolab/chwala" -> "projectatomic/mariadb-centos7-atomicapp" [label="(63)"];

            "kolab/ext-mx-in" -> "kolab/asav"           [label="(3)"];
            "kolab/ext-mx-in" -> "kolab/int-mx"         [label="(4)"];
            "kolab/ext-mx-in" -> "kolab/ldap-slave"     [label="(5)"];

            "kolab/ext-mx-out" -> "kolab/asav"          [label="(6)"];
            "kolab/ext-mx-out" -> "kolab/int-mx"        [label="(7)"];

            "kolab/freebusy" -> "kolab/imapf-int"       [label="(8)"];
            "kolab/freebusy" -> "kolab/ldap-slave"      [label="(9)"];
            "kolab/freebusy" -> "projectatomic/mariadb-centos7-atomicapp" [label="(10)"];

            "kolab/http-prx" -> "kolab/chwala"          [label="(60)"];
            "kolab/http-prx" -> "kolab/freebusy"        [label="(48)"];
            "kolab/http-prx" -> "kolab/irony"           [label="(49)"];
            "kolab/http-prx" -> "kolab/roundcubemail"   [label="(50)"];
            "kolab/http-prx" -> "kolab/syncroton"       [label="(51)"];
            "kolab/http-prx" -> "kolab/webadmin"        [label="(52)"];

            "kolab/imap-mupdate" -> "kolab/imapf-int"   [label="(11)"];
            "kolab/imap-mupdate" -> "kolab/imapf-ext"   [label="(12)"];
            "kolab/imap-mupdate" -> "kolab/ldap-slave"  [label="(13)"];

            "kolab/imapb" -> "kolab/imap-mupdate"       [label="(14)"];
            "kolab/imapb" -> "kolab/int-mx"             [label="(15)"];
            "kolab/imapb" -> "kolab/ldap-slave"         [label="(16)"];

            "kolab/imapf-ext" -> "kolab/imap-mupdate"   [label="(17)"];
            "kolab/imapf-ext" -> "kolab/imapb"          [label="(18)"];
            "kolab/imapf-ext" -> "kolab/ldap-slave"     [label="(19)"];

            "kolab/imapf-int" -> "kolab/imap-mupdate"   [label="(20)"];
            "kolab/imapf-int" -> "kolab/imapb"          [label="(21)"];
            "kolab/imapf-int" -> "kolab/ldap-slave"     [label="(22)"];

            "kolab/imap-mupdate" -> "kolab/imapf-ext"   [label="(23)"];
            "kolab/imap-mupdate" -> "kolab/imapf-int"   [label="(24)"];
            "kolab/imap-mupdate" -> "kolab/ldap-slave"  [label="(25)"];

            "kolab/imap-prx" -> "kolab/imapf-ext"       [label="(26)"];
            "kolab/imap-prx" -> "kolab/ldap-slave"      [label="(27)"];

            "kolab/int-mx" -> "kolab/ext-mx-out"        [label="(28)"];
            "kolab/int-mx" -> "kolab/imapb"             [label="(29)"];
            "kolab/int-mx" -> "kolab/ldap-slave"        [label="(30)"];
            "kolab/int-mx" -> "kolab/wallace"           [label="(31)"];

            "kolab/irony" -> "kolab/imapf-int"          [label="(32)"];
            "kolab/irony" -> "kolab/ldap-slave"         [label="(33)"];
            "kolab/irony" -> "projectatomic/mariadb-centos7-atomicapp" [label="(34)"];

            "kolab/kolabd" -> "kolab/imapb"             [label="(53)"];
            "kolab/kolabd" -> "kolab/imapf-int"         [label="(54)"];
            "kolab/kolabd" -> "kolab/ldap-master"       [label="(55)"];

            "kolab/ldap-master" -> "kolab/ldap-slave"   [label="(35)"];

            "kolab/roundcubemail" -> "kolab/freebusy"   [label="(36)"];
            "kolab/roundcubemail" -> "kolab/imapf-int"  [label="(37)"];
            "kolab/roundcubemail" -> "projectatomic/mariadb-centos7-atomicapp" [label="(38)"];

            "kolab/submission" -> "kolab/int-mx"        [label="(39)"];
            "kolab/submission" -> "kolab/ldap-slave"    [label="(40)"];

            "kolab/syncroton" -> "kolab/imapf-int"      [label="(41)"];
            "kolab/syncroton" -> "projectatomic/mariadb-centos7-atomicapp" [label="(42)"];

            "kolab/wallace" -> "kolab/imapf-int"        [label="(43)"];
            "kolab/wallace" -> "kolab/int-mx"           [label="(44)"];
            "kolab/wallace" -> "kolab/ldap-slave"       [label="(45)"];

            "kolab/webadmin" -> "kolab/ldap-master"     [label="(46)"];
            "kolab/webadmin" -> "projectatomic/mariadb-centos7-atomicapp" [label="(47)"];


            "External SMTP Servers" -> "kolab/ext-mx-in"[label="(56)"];
            "User / Client" -> "kolab/http-prx"         [label="(57)"];
            "User / Client" -> "kolab/imap-prx"         [label="(58)"];
            "User / Client" -> "kolab/submission"       [label="(59)"];
        }

