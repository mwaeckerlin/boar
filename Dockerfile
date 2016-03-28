FROM mwaeckerlin/ssh
MAINTAINER mwaeckerlin
ENV TERM xterm

ENV USER="boar"
ENV GROUP="boar"
ENV BOAR_SOURCE "https://bitbucket.org/mats_ekberg/boar/downloads/boar.16-Nov-2012.tar.gz"

EXPOSE 22

WORKDIR /opt
RUN apt-get update
RUN apt-get -y install python wget mcrypt
RUN wget -O- ${BOAR_SOURCE} | tar xz
ADD boar /usr/local/bin/boar
RUN useradd -ms /bin/bash -d /home/boar $USER
RUN boar mkrepo /boar
RUN chown -R ${USER}.${GROUP} /boar
WORKDIR /boar

USER root
CMD /start.sh

VOLUME /boar
