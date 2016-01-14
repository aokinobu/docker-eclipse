#FROM ubuntu:trusty
FROM debian:jessie
MAINTAINER Nobuyuki Aoki "aokinobu@gmail.com"

#RUN sed 's/main$/main universe/' -i /etc/apt/sources.list && \
#    apt-get update && apt-get install -y software-properties-common && \
#    add-apt-repository ppa:webupd8team/java -y && \
#    apt-get update && \
#    echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections && \
#    apt-get install -y oracle-java8-installer libxext-dev libxrender-dev libxtst-dev && \
#    apt-get clean && \
#    rm -rf /var/lib/apt/lists/* && \
#    rm -rf /tmp/*

# http://www.webupd8.org/2014/03/how-to-install-oracle-java-8-in-debian.html
RUN echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee /etc/apt/sources.list.d/webupd8team-java.list && \
    echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee -a /etc/apt/sources.list.d/webupd8team-java.list && \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886 && \
    apt-get update && \
    echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections && \
    apt-get install -y oracle-java8-installer libxext-dev libxrender-dev libxtst-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/*


# Install libgtk as a separate step so that we can share the layer above with
# the netbeans image
RUN apt-get update && apt-get install -y libgtk2.0-0 libcanberra-gtk-module

RUN wget http://ftp.yz.yamagata-u.ac.jp/pub/eclipse//technology/epp/downloads/release/mars/1/eclipse-jee-mars-1-linux-gtk-x86_64.tar.gz -O /tmp/eclipse.tar.gz -q && \
    echo 'Installing eclipse' && \
    tar -xf /tmp/eclipse.tar.gz -C /opt && \
    rm /tmp/eclipse.tar.gz

ADD run /usr/local/bin/eclipse

RUN apt-get install -y sudo
RUN chmod +x /usr/local/bin/eclipse && \
    mkdir -p /home/developer && \
    echo "developer:x:1000:1000:Developer,,,:/home/developer:/bin/bash" >> /etc/passwd && \
    echo "developer:x:1000:" >> /etc/group && \
    echo "developer ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/developer && \
    chmod 0440 /etc/sudoers.d/developer && \
    chown developer:developer -R /home/developer && \
    chown root:root /usr/bin/sudo && chmod 4755 /usr/bin/sudo

#RUN /usr/local/bin/eclipse -nosplash \
#  -application org.eclipse.equinox.p2.director \
#  -repository http://download.eclipse.org/releases/mars/ \
#  -destination /opt/eclipse \
#  -installIU net.sourceforge.vrapper.feature.group

RUN apt-get install -y net-tools telnet
RUN apt-get install -y ssh
RUN apt-get update; apt-get install -y chromium

USER developer
ENV HOME /home/developer
WORKDIR /home/developer
CMD /usr/local/bin/eclipse
