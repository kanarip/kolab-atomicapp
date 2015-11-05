# Kolab Groupware Base Image

Take `projectatomic/atomicapp`, then add the Kolab repositories, and
for the time being, also ensure some debugging utilities and other such
are installed (**lsof**, **strace**, **net-tools**, etc.).

The resulting image forms the base for other images.
