#!/bin/bash -e

/config-ldap.sh
/etc/init.d/nscd start
if ! id "$BOAR_USER" 2> /dev/null > /dev/null; then
    echo "setup /boar ..."
    useradd -ms /bin/bash -d "/home/$BOAR_USER" -g "$BOAR_GROUP" "$BOAR_USER"
fi

echo "fixing permissions"
chown -R "${BOAR_USER}.${BOAR_GROUP}" /boar
chmod -R g+rwx /boar
find /boar -type d -exec chmod g+rwx {} \;

echo "configure ssh"
if test -n "$SSH_PUBKEY" -a ! grep -q "$SSH_PUBKEY" "/home/${BOAR_USER}/.ssh"; then
    mkdir "/home/${BOAR_USER}/.ssh"
    echo "$SSH_PUBKEY" >> "/home/${BOAR_USER}/.ssh/authorized_keys"
    chown -R "${BOAR_USER}.${BOAR_GROUP}" "/home/${BOAR_USER}/.ssh"
fi

echo "ready, starting ssh daemon..."
/usr/sbin/sshd $SSHOPTIONS -D
