#!/bin/bash

uid $USER > /dev/null 2>&1 || useradd -ms /bin/bash -d /home/boar $USER
chown -R ${USER}.${USER} /boar
echo ${USER}:${PASSWORD} | chpasswd

/etc/init.d/nscd start
/usr/sbin/sshd -D
