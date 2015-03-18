FROM ubuntu:12.04
MAINTAINER Holger May <docker@iomq.org>

#ENV
ENV DEBIAN_FRONTEND noninteractive
ENV DOCKER_DIR /docker
ENV DOCKERXDEBUG YES

# Install packages
RUN apt-get update
RUN apt-get -y dselect-upgrade
RUN apt-get -y install apt-utils dialog
RUN apt-get -y install telnet vim inetutils-ping
RUN apt-get -y install git
RUN apt-get -y install supervisor
RUN apt-get -y install ssmtp
RUN apt-get -y install mysql-server mysql-client
RUN apt-get -y install graphicsmagick graphicsmagick-imagemagick-compat language-pack-de gettext intltool catdoc htmldoc
RUN apt-get -y install apache2 libapache2-mod-php5 php5-mysql php5-gd php5-mcrypt php5-curl php5-xsl
RUN apt-get -y install php-apc
RUN apt-get -y install php5-cli
RUN apt-get -y install php5-xdebug
RUN echo "0.0.0.15" > /etc/iomq_version
RUN apt-get update -qq && apt-get -y dselect-upgrade

ADD https://phar.phpunit.de/phpunit.phar /usr/local/bin/phpunit
ADD https://phar.phpunit.de/phpcpd.phar /usr/local/bin/phpcpd
ADD https://phar.phpunit.de/phpdcd.phar /usr/local/bin/phpdcd
ADD https://phar.phpunit.de/phploc.phar /usr/local/bin/phploc
RUN chmod a+rx /usr/local/bin/php*
