FROM ubuntu
MAINTAINER mwaekerlin
ENV TERM xterm

ENV USER="boar"
ENV PASSWORD="S3cRe7"
ENV BOAR_SOURCE "https://bitbucket.org/mats_ekberg/boar/downloads/boar.16-Nov-2012.tar.gz"

EXPOSE 22

WORKDIR /opt
RUN apt-get update
RUN apt-get -y install python wget openssh-server mcrypt
RUN wget -O- ${BOAR_SOURCE} | tar xz
RUN mkdir /var/run/sshd
RUN sed -i 's,passwd:.*,passwd: ldap compat,' /etc/nsswitch.conf
RUN sed -i 's,group:.*,group: ldap compat,' /etc/nsswitch.conf
RUN sed -i 's,shadow:.*,shadow: ldap compat,' /etc/nsswitch.conf
RUN echo 'session required    pam_mkhomedir.so skel=/etc/skel umask=0022' >> /etc/pam.d/common-session
#RUN sed -i 's,^ *PermitEmptyPasswords .*,PermitEmptyPasswords yes,' /etc/ssh/sshd_config
#RUN sed -i '1iauth sufficient pam_permit.so' /etc/pam.d/sshd
USER root
ADD boar /usr/local/bin/boar
RUN boar mkrepo /boar
WORKDIR /boar
ADD start.sh /start.sh
CMD /start.sh

VOLUME /boar
VOLUME /home/boar
