#!/bin/bash -e

/config-ldap.sh
/etc/init.d/nscd start
if ! test -d /home/${BOAR_USER}; then
    useradd -ms /bin/bash -d /home/$BOAR_USER -g $BOAR_GROUP $BOAR_USER
    chown -R ${BOAR_USER}.${BOAR_GROUP} /boar
    chmod -R g+w /boar
fi
/usr/sbin/sshd -D
