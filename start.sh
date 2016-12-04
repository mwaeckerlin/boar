#!/bin/bash -e

/config-ldap.sh
/etc/init.d/nscd start
if ! test -d "/home/${BOAR_USER}"; then
    echo "setup /boar ..."
    useradd -ms /bin/bash -d "/home/$BOAR_USER" -g "$BOAR_GROUP" "$BOAR_USER"
fi

echo "fixing permissions"
chown -R "${BOAR_USER}.${BOAR_GROUP}" /boar
chmod -R g+rwx /boar
find /boar -type d -exec chmod g+rwx {} \;

echo "configure ssh"
if test -n "$SSH_PUBKEY" -a ! -d ~${BOAR_USER}/.ssh; then
    mkdir ~${BOAR_USER}/.ssh
    echo "$SSH_PUBKEY" > ~${BOAR_USER}/.ssh/authorized_keys
    chown -R "${BOAR_USER}.${BOAR_GROUP}" ~${BOAR_USER}/.ssh
fi

echo "ready, starting ssh daemon..."
/usr/sbin/sshd $SSHOPTIONS -D
