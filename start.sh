#!/bin/bash -e

/config-ldap.sh
/etc/init.d/nscd start
if ! id "$BOAR_USER" 2> /dev/null > /dev/null; then
    echo "create boar user ..."
    useradd -ms /bin/bash -d "/home/$BOAR_USER" -g "$BOAR_GROUP" "$BOAR_USER"
fi

echo "fixing permissions"
chown -R "${BOAR_USER}.${BOAR_GROUP}" /boar
chmod -R g+rwx /boar
find /boar -type d -exec chmod g+rwx {} \;

if test -n "$SSH_PUBKEY" && ! grep -q "$SSH_PUBKEY" "/home/${BOAR_USER}/.ssh/authorized_keys"; then
    echo "configure ssh"
    mkdir "/home/${BOAR_USER}/.ssh"
    echo "$SSH_PUBKEY" >> "/home/${BOAR_USER}/.ssh/authorized_keys"
    chown -R "${BOAR_USER}.${BOAR_GROUP}" "/home/${BOAR_USER}/.ssh"
fi

echo "ready, starting ssh daemon..."
#/usr/sbin/sshd $SSHOPTIONS -D
/usr/sbin/sshd $SSHOPTIONS

echo "start fixing permissions..."
inotifywait -m -r --format '%e %w%f' -e modify,moved_to,create @/boar/tmp /boar |
    while read e p; do
        echo -n "$(date) fix permissions: $e → $p... "
        if test -e "$p"; then
            chown -R "${BOAR_USER}.${BOAR_GROUP}" "$p" && echo "done." || echo "failed."
        else
            echo "ignored."
        fi
    done
