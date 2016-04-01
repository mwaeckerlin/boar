#!/bin/bash -e

/config-ldap.sh
/etc/init.d/nscd start
if ! test -d /home/${BOAR_USER}; then
    echo "setup /boar ..."
    useradd -ms /bin/bash -d /home/$BOAR_USER -g $BOAR_GROUP $BOAR_USER
    chown -R ${BOAR_USER}.${BOAR_GROUP} /boar
    chmod -R g+w /boar
fi

echo "ready, starting ssh daemon..."
/usr/sbin/sshd $SSHOPTIONS -D
