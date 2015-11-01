# Kolab Groupware as an Atomic Application

This repository contains the development of
[Kolab Groupware](https://kolab.org) as an
[Atomic Application](http://www.projectatomic.io/docs/atomicapp/) for
deployment on Kubernetes-based environments, such as
[OpenShift](https://www.openshift.com/) /
[Atomic](http://www.projectatomic.io), using
[Nulecule](http://www.projectatomic.io/docs/nulecule/).

## Run in Vagrant

Run the Kolab Atomic Application in the Atomic Developer Bundle Vagrant
image.

    $ vagrant up
    $ vagrant ssh
    $ atomic install kolab/atomicapp

Edit `./answers.conf.sample` and save off as `./answers.conf`.

    $ atomic run kolab/atomicapp

## Limitations

  * Nulecule does yet provide containers with persistent volumes.

  * Option value (i.e. use MySQL, MariaDB or PostgreSQL) cannot simply
    be orchestrated.

