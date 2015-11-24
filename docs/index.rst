========================
Kolab Atomic Application
========================

The Kolab Atomic application is a suite of Nulecule applications built
for the most elastic type of environments.

Every application itself, as well as every role such application may
take in the overall environment, is separated out in to separate
containers.

For example, Inbound Mail Exchangers are designed to offer the highest
grade of protection against spammers and other abusers. This means the
mail exchanger applies :command:`postscreen`, grey-listing, anti-spam
and anti-virus (running in another container), but only recipient
domain validation, and no recipient validation.

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

            "centos/centos7";
            "projectatomic/atomicapp";
            "rhel7";

            "kolab/base";
            "kolab/base-asav";
            "kolab/base-imap";
            "kolab/base-ldap";
            "kolab/base-mx";
            "kolab/base-web";
            "kolab/base-web-rc";

            "kolab/mongodb";

            subgraph cluster_asav {
                    color = white;

                    "kolab/asav-in";
                    "kolab/asav-out";
                }

            subgraph cluster_imap {
                    color = white;

                    "kolab/guam";
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

                    "kolab/asav-in";
                    "kolab/asav-out";
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
                    "kolab/manticore";
                    "kolab/roundcubemail";
                    "kolab/syncroton";
                    "kolab/webadmin";
                }

            "centos/centos7" -> "kolab/mongodb" [dir=back];
            "rhel7" -> "projectatomic/atomicapp" [dir=back];
            "projectatomic/atomicapp" -> "kolab/base" [dir=back];

            "kolab/base" -> "kolab/base-asav" [dir=back];
            "kolab/base" -> "kolab/base-imap" [dir=back];
            "kolab/base" -> "kolab/base-ldap" [dir=back];
            "kolab/base" -> "kolab/base-mx" [dir=back];
            "kolab/base" -> "kolab/base-web" [dir=back];
            "kolab/base" -> "kolab/kolabd" [dir=back];
            "kolab/base" -> "kolab/manticore" [dir=back];

            "kolab/base-asav" ->
                    "kolab/asav-in",
                    "kolab/asav-out" [dir=back];

            "kolab/base-imap" ->
                    "kolab/guam",
                    "kolab/imapf-int",
                    "kolab/imapf-ext",
                    "kolab/imap-mupdate",
                    "kolab/imapb" [dir=back];

            "kolab/base-ldap" ->
                    "kolab/ldap-master",
                    "kolab/ldap-slave" [dir=back];

            "kolab/base-mx" ->
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

                    "kolab/mongdb-centos7-atomicapp";
                    "projectatomic/mariadb-centos7-atomicapp";
                }

            "kolab/kolabd";

            subgraph cluster_asav {
                    color = white;

                    "kolab/asav-in";
                    "kolab/asav-out";
                }

            subgraph cluster_imap {
                    color = white;

                    "kolab/guam";
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
                    "kolab/manticore";
                    "kolab/roundcubemail";
                    "kolab/syncroton";
                    "kolab/webadmin";
                }

            "kolab/asav-in" -> "kolab/ext-mx-in"        [label="(1)"];
            "kolab/asav-out" -> "kolab/ext-mx-out"      [label="(2)"];

            "kolab/chwala" -> "kolab/imapf-int"         [label="(61)"];
            "kolab/chwala" -> "kolab/ldap-slave"        [label="(62)"];
            "kolab/chwala" -> "projectatomic/mariadb-centos7-atomicapp" [label="(63)"];

            "kolab/ext-mx-in" -> "kolab/asav-in"        [label="(3)"];
            "kolab/ext-mx-in" -> "kolab/int-mx"         [label="(4)"];
            "kolab/ext-mx-in" -> "kolab/ldap-slave"     [label="(5)"];

            "kolab/ext-mx-out" -> "kolab/asav-out"      [label="(6)"];
            "kolab/ext-mx-out" -> "kolab/int-mx"        [label="(7)"];

            "kolab/freebusy" -> "kolab/imapf-int"       [label="(8)"];
            "kolab/freebusy" -> "kolab/ldap-slave"      [label="(9)"];
            "kolab/freebusy" -> "projectatomic/mariadb-centos7-atomicapp" [label="(10)"];

            "kolab/http-prx" -> "kolab/chwala"          [label="(60)"];
            "kolab/http-prx" -> "kolab/freebusy"        [label="(48)"];
            "kolab/http-prx" -> "kolab/irony"           [label="(49)"];
            "kolab/http-prx" -> "kolab/manticore"       [label="(66)"];
            "kolab/http-prx" -> "kolab/roundcubemail"   [label="(50)"];
            "kolab/http-prx" -> "kolab/syncroton"       [label="(51)"];
            "kolab/http-prx" -> "kolab/webadmin"        [label="(52)"];

            "kolab/imap-mupdate" -> "kolab/imapf-ext"   [label="(11)"];
            "kolab/imap-mupdate" -> "kolab/imapf-int"   [label="(12)"];
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

            "kolab/guam" -> "kolab/imapf-ext"       [label="(26)"];
            "kolab/guam" -> "kolab/ldap-slave"      [label="(27)"];

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

            "kolab/manticore" -> "centos/mongodb-26-centos7" [label="(64)"];
            "kolab/manticore" -> "kolab/chwala"         [label="(65)"];

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
            "User / Client" -> "kolab/guam"         [label="(58)"];
            "User / Client" -> "kolab/submission"       [label="(59)"];
        }

.. table:: Connection Diagram Table

    +----+---------------------+-----------------------------------------+-------------+-----------------------+
    |  # | Source Container    | Target Pod                              | Target Port | Description           |
    +====+=====================+=========================================+=============+=======================+
    |  1 | kolab/asav-in       | kolab/ext-mx-in                         |   10024/tcp | Re-submission after   |
    |    |                     |                                         |             | Anti-Spam and Anti-   |
    |    |                     |                                         |             | Virus checks. [#]_    |
    +----+---------------------+-----------------------------------------+-------------+-----------------------+
    |  2 | kolab/asav-out      | kolab/ext-mx-out                        |   10024/tcp |                       |
    +----+---------------------+-----------------------------------------+-------------+-----------------------+
    |  3 | kolab/ext-mx-in     | kolab/asav-in                           |      ??/tcp |                       |
    +----+---------------------+-----------------------------------------+-------------+-----------------------+
    |  4 | kolab/ext-mx-in     | kolab/int-mx                            |      ??/tcp |                       |
    +----+---------------------+-----------------------------------------+-------------+-----------------------+
    |  5 | kolab/ext-mx-in     | kolab/ldap-slave                        |      ??/tcp |                       |
    +----+---------------------+-----------------------------------------+-------------+-----------------------+
    |  6 | kolab/ext-mx-out    | kolab/asav-out                          |      ??/tcp |                       |
    +----+---------------------+-----------------------------------------+-------------+-----------------------+
    |  7 | kolab/ext-mx-out    | kolab/int-mx                            |      ??/tcp | NDR and DSN messages. |
    +----+---------------------+-----------------------------------------+-------------+-----------------------+
    |  8 | kolab/freebusy      | kolab/imapf-int                         |      ??/tcp |                       |
    +----+---------------------+-----------------------------------------+-------------+-----------------------+
    |  9 | kolab/freebusy      | kolab/ldap-slave                        |      ??/tcp |                       |
    +----+---------------------+-----------------------------------------+-------------+-----------------------+
    | 10 | kolab/freebusy      | projectatomic/mariadb-centos7-atomicapp |      ??/tcp |                       |
    +----+---------------------+-----------------------------------------+-------------+-----------------------+
    | 11 | kolab/imap-mupdate  | kolab/...                               |      ??/tcp |                       |
    +----+---------------------+-----------------------------------------+-------------+-----------------------+
    | 12 | kolab/imap-mupdate  | kolab/...                               |      ??/tcp |                       |
    +----+---------------------+-----------------------------------------+-------------+-----------------------+
    | 13 | kolab/imap-mupdate  | kolab/...                               |      ??/tcp |                       |
    +----+---------------------+-----------------------------------------+-------------+-----------------------+
    | 14 | kolab/imapb         | kolab/...                               |      ??/tcp |                       |
    +----+---------------------+-----------------------------------------+-------------+-----------------------+
    | 15 | kolab/imapb         | kolab/...                               |      ??/tcp |                       |
    +----+---------------------+-----------------------------------------+-------------+-----------------------+
    | 16 | kolab/imapb         | kolab/...                               |      ??/tcp |                       |
    +----+---------------------+-----------------------------------------+-------------+-----------------------+
    | 17 | kolab/imapf-ext     | kolab/...                               |      ??/tcp |                       |
    +----+---------------------+-----------------------------------------+-------------+-----------------------+
    | 18 | kolab/imapf-ext     | kolab/...                               |      ??/tcp |                       |
    +----+---------------------+-----------------------------------------+-------------+-----------------------+
    | 19 | kolab/imapf-ext     | kolab/...                               |      ??/tcp |                       |
    +----+---------------------+-----------------------------------------+-------------+-----------------------+
    | 20 | kolab/imapf-int     | kolab/...                               |      ??/tcp |                       |
    +----+---------------------+-----------------------------------------+-------------+-----------------------+
    | 21 | kolab/imapf-int     | kolab/...                               |      ??/tcp |                       |
    +----+---------------------+-----------------------------------------+-------------+-----------------------+
    | 22 | kolab/imapf-int     | kolab/...                               |      ??/tcp |                       |
    +----+---------------------+-----------------------------------------+-------------+-----------------------+
    | 26 | kolab/guam          | kolab/...                               |      ??/tcp |                       |
    +----+---------------------+-----------------------------------------+-------------+-----------------------+
    | 27 | kolab/guam          | kolab/...                               |      ??/tcp |                       |
    +----+---------------------+-----------------------------------------+-------------+-----------------------+
    | 28 | kolab/int-mx        | kolab/...                               |      ??/tcp |                       |
    +----+---------------------+-----------------------------------------+-------------+-----------------------+
    | 29 | kolab/int-mx        | kolab/...                               |      ??/tcp |                       |
    +----+---------------------+-----------------------------------------+-------------+-----------------------+
    | 30 | kolab/int-mx        | kolab/...                               |      ??/tcp |                       |
    +----+---------------------+-----------------------------------------+-------------+-----------------------+
    | 31 | kolab/int-mx        | kolab/...                               |      ??/tcp |                       |
    +----+---------------------+-----------------------------------------+-------------+-----------------------+
    | 32 | kolab/irony         | kolab/...                               |      ??/tcp |                       |
    +----+---------------------+-----------------------------------------+-------------+-----------------------+
    | 33 | kolab/irony         | kolab/...                               |      ??/tcp |                       |
    +----+---------------------+-----------------------------------------+-------------+-----------------------+
    | 34 | kolab/irony         | kolab/...                               |      ??/tcp |                       |
    +----+---------------------+-----------------------------------------+-------------+-----------------------+
    | 35 | kolab/ldap-master   | kolab/...                               |      ??/tcp |                       |
    +----+---------------------+-----------------------------------------+-------------+-----------------------+
    | 36 | kolab/roundcubemail | kolab/...                               |      ??/tcp |                       |
    +----+---------------------+-----------------------------------------+-------------+-----------------------+
    | 37 | kolab/roundcubemail | kolab/...                               |      ??/tcp |                       |
    +----+---------------------+-----------------------------------------+-------------+-----------------------+
    | 38 | kolab/roundcubemail | kolab/...                               |      ??/tcp |                       |
    +----+---------------------+-----------------------------------------+-------------+-----------------------+
    | 39 | kolab/submission    | kolab/...                               |      ??/tcp |                       |
    +----+---------------------+-----------------------------------------+-------------+-----------------------+
    | 40 | kolab/submission    | kolab/...                               |      ??/tcp |                       |
    +----+---------------------+-----------------------------------------+-------------+-----------------------+
    | 41 | kolab/syncroton     | kolab/...                               |      ??/tcp |                       |
    +----+---------------------+-----------------------------------------+-------------+-----------------------+
    | 42 | kolab/syncroton     | kolab/...                               |      ??/tcp |                       |
    +----+---------------------+-----------------------------------------+-------------+-----------------------+
    | 43 | kolab/wallace       | kolab/...                               |      ??/tcp |                       |
    +----+---------------------+-----------------------------------------+-------------+-----------------------+
    | 44 | kolab/wallace       | kolab/...                               |      ??/tcp |                       |
    +----+---------------------+-----------------------------------------+-------------+-----------------------+
    | 45 | kolab/wallace       | kolab/...                               |      ??/tcp |                       |
    +----+---------------------+-----------------------------------------+-------------+-----------------------+
    | 46 | kolab/webadmin      | kolab/...                               |      ??/tcp |                       |
    +----+---------------------+-----------------------------------------+-------------+-----------------------+
    | 47 | kolab/webadmin      | kolab/...                               |      ??/tcp |                       |
    +----+---------------------+-----------------------------------------+-------------+-----------------------+
    | 48 | kolab/http-prx      | kolab/...                               |      ??/tcp |                       |
    +----+---------------------+-----------------------------------------+-------------+-----------------------+
    | 49 | kolab/http-prx      | kolab/...                               |      ??/tcp |                       |
    +----+---------------------+-----------------------------------------+-------------+-----------------------+
    | 50 | kolab/http-prx      | kolab/roundcubemail                     |  80,443/tcp |                       |
    +----+---------------------+-----------------------------------------+-------------+-----------------------+
    | 51 | kolab/http-prx      | kolab/...                               |      ??/tcp |                       |
    +----+---------------------+-----------------------------------------+-------------+-----------------------+
    | 52 | kolab/http-prx      | kolab/...                               |      ??/tcp |                       |
    +----+---------------------+-----------------------------------------+-------------+-----------------------+
    | 53 | kolab/kolabd        | kolab/...                               |      ??/tcp |                       |
    +----+---------------------+-----------------------------------------+-------------+-----------------------+
    | 54 | kolab/kolabd        | kolab/...                               |      ??/tcp |                       |
    +----+---------------------+-----------------------------------------+-------------+-----------------------+
    | 55 | kolab/kolabd        | kolab/...                               |      ??/tcp |                       |
    +----+---------------------+-----------------------------------------+-------------+-----------------------+
    | 56 | Ext. SMTP Servers   | kolab/...                               |      ??/tcp |                       |
    +----+---------------------+-----------------------------------------+-------------+-----------------------+
    | 57 | User / Client       | kolab/...                               |      ??/tcp |                       |
    +----+---------------------+-----------------------------------------+-------------+-----------------------+
    | 58 | User / Client       | kolab/...                               |      ??/tcp |                       |
    +----+---------------------+-----------------------------------------+-------------+-----------------------+
    | 59 | User / Client       | kolab/...                               |      ??/tcp |                       |
    +----+---------------------+-----------------------------------------+-------------+-----------------------+
    | 60 | kolab/http-prx      | kolab/...                               |      ??/tcp |                       |
    +----+---------------------+-----------------------------------------+-------------+-----------------------+
    | 61 | kolab/chwala        | kolab/...                               |      ??/tcp |                       |
    +----+---------------------+-----------------------------------------+-------------+-----------------------+
    | 62 | kolab/chwala        | kolab/...                               |      ??/tcp |                       |
    +----+---------------------+-----------------------------------------+-------------+-----------------------+
    | 63 | kolab/chwala        | kolab/...                               |      ??/tcp |                       |
    +----+---------------------+-----------------------------------------+-------------+-----------------------+
    | 64 | kolab/manticore     | centos/mongodb-26-centos7               |      ??/tcp |                       |
    +----+---------------------+-----------------------------------------+-------------+-----------------------+
    | 65 | kolab/manticore     | kolab/chwala                            |      ??/tcp |                       |
    +----+---------------------+-----------------------------------------+-------------+-----------------------+
    | 66 | kolab/http-prx      | kolab/manticore                         |      ??/tcp |                       |
    +----+---------------------+-----------------------------------------+-------------+-----------------------+


Container Images
================

``base``
--------

Based on ``centos:centos7``.

Installs the ``Kolab:Development/CentOS_7`` software repository, the
**yum-plugin-priorities** package, and installs the GPG key.

Adds common functionality used in other images' entry points in a file
:file:`/functions.sh`.

``base-asav``
-------------

Installs the necessary Anti-Spam and Anti-Virus software. As it does not need to
be customized further, also adds the :file:`/entrypoint.sh`. Consumer images
should set an environment variable ``KOLAB_ROLE`` to either ``ASAV_IN`` or
``ASAV_OUT``, so that the entrypoint can decide whether to re-inject messages
to the server at ``KOLAB_EXT_MX_IN_SERVICE_HOST`` or
``KOLAB_EXT_MX_OUT_SERVICE_HOST``, and what policy banks to apply.

``base-imap``
-------------

Installs the necessary software for IMAP functionality, such as **cyrus-imapd**
and **kolab-saslauthd**.

Configures the command to run upon executing the container's entrypoint, along
the lines of :command:`/usr/lib/cyrus-imapd/cyrus-master -L /dev/null`.

``base-ldap``
-------------

Installs the necessary software for LDAP functionality, such as **389-ds**.

Also installs the Kolab schema extensions, and replaces the default
:file:`/usr/share/dirsrv/data/template.ldif` with a version that makes Kolab
function.

``base-mx``
-----------

Installs the necessary software for mail-exchanger functionality, such as
**postfix** and **postfix-kolab**.

Also sets the command to run upon executing a container's entry point to
something along the lines of :command:`/usr/libexec/postfix/master -D`.

``base-web``
------------

Installs the necessary software to run web services, such as **httpd**.

Also sets the command to execute upon entry to
:command:`/usr/sbin/httpd -DFOREGROUND`.

``base-web-rc``
---------------

In addition to the software installed on ``base-web``, installs
**roundcubemail** and **roundcubemail-plugins-kolab**.

Keeping this a separate image helps to re-use the base image for a variety of
other micro-services.

``asav-in``
-----------

Anti-Spam and Anti-Virus tailored to entertain inbound message traffic.

``asav-out``
------------

Anti-Spam and Anti-Virus tailored to entertain outbound message traffic -- such
as applying DKIM signatures.

``chwala``
----------

File Cloud.

``ext-mx-in``
-------------

Inbound External Mail Exchanger. Must be able to take a degree of abuse.

``ext-mx-out``
--------------

Outbound External Mail Exchanger. Should aid to eliviate Internal Mail
Exchanger's message queues should recipient mail exchangers not be available.

``freebusy``
------------

Scheduling information.

``guam``
--------

Reverse proxy for IMAP with spicy sauce. Enables filtering IMAP folders that
contain groupware data for those clients that do not understand how to interpret
such -- i.e. all IMAP clients aside from Kontact and Roundcube with Kolab
plugins.

``http-prx``
------------

For all the micro-services that are web services, have one entrypoint.

``imapb``
---------

An IMAP backend. Contains payload (mailboxes).

``imapf-ext``
-------------

An external-facing IMAP frontend. Must be able to take a degree of abuse.

``imapf-int``
-------------

An internal-facing IMAP frontend, for use with internal micro-services such as
many of the web-based micro-services.

This functionality is separated from the ``imapf-ext`` functionality, because
internal traffic has far lower security and audit requirements.

``imap-mupdate``
----------------

The IMAP aggregator master service.

``int-mx``
----------

Internal mail exchanger. For a domain ``example.org``, all inbound traffic is
ultimately relayed to this service, all internal traffic is submitted here,
aliases are translated here, distribution groups are expanded here.

``irony``
---------

*DAV protocol access layer to Kolab Groupware.

``ldap-master``
---------------

389 Directory Server services set up just right for Kolab. Scalability and
redundancy requirements dictate that the read- and write- functionality is split
between at least a master and one-or-more slaves.

``ldap-slave``
--------------

``manticore``
-------------

Collaborative editing services for documents in the Open Document Format (ODF).

``roundcubemail``
-----------------

The webmail client.

``submission``
--------------

Submission services for external clients.

``syncroton``
-------------

ActiveSync.

``wallace``
-----------

Kolab content filter with resource scheduling, invitation policies and GPG
encryption.

``webadmin``
------------

The Web Administration Panel to LDAP.

``chwala-database``
-------------------

``freebusy-database``
---------------------

``irony-database``
------------------

``roundcubemail-database``
--------------------------

``syncroton-database``
----------------------

``webadmin-database``
---------------------

``asav-in-atomicapp``
---------------------

``asav-out-atomicapp``
----------------------

``chwala-atomicapp``
--------------------

``ext-mx-in-atomicapp``
-----------------------

``ext-mx-out-atomicapp``
------------------------

``freebusy-atomicapp``
----------------------

``guam-atomicapp``
------------------

``imapb-atomicapp``
-------------------

``imapf-ext-atomicapp``
-----------------------

``imapf-int-atomicapp``
-----------------------

``imap-mupdate-atomicapp``
--------------------------

``int-mx-atomicapp``
--------------------

``irony-atomicapp``
-------------------

``ldap-master-atomicapp``
-------------------------

``ldap-slave-atomicapp``
------------------------

``manticore-atomicapp``
-----------------------

``roundcubemail-atomicapp``
---------------------------

``submission-atomicapp``
------------------------

``syncroton-atomicapp``
-----------------------

``wallace-atomicapp``
---------------------

``webadmin-atomicapp``
----------------------

``atomicapp``
-------------
