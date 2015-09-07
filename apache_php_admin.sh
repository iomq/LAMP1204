#!/bin/bash

echo "Include /docker/conf/apache/sites-enabled_1204/*.conf" > /etc/apache2/sites-available/default
echo "ServerName localhost" > /etc/apache2/conf.d/name

mkdir -p /usr/local/php/bin/
ln -s /usr/bin/composite /usr/local/php/bin/composite
ln -s /usr/bin/convert /usr/local/php/bin/convert
ln -s /usr/bin/gm /usr/local/php/bin/gm
ln -s /usr/bin/identify /usr/local/php/bin/identify

#APACHE
WORKDIR=${WORKDIR:-"/var/www"}
chown nobody.nogroup $WORKDIR
APACHE_MYUSER=${APACHE_MYUSER:-""}
APACHE_CHANGEUSER=${APACHE_CHANGEUSER:-""}
APACHE_USER=${APACHE_USER:-"www-data"}
APACHE_GROUP=${APACHE_GROUP:-"www-data"}

if [[ $APACHE_MYUSER != "" ]]; then
APACHE_USERID=${APACHE_USERID:-"1000"}
useradd --uid $APACHE_USERID --home /home/$APACHE_USER -m --shell /bin/bash $APACHE_USER

checkhomelamp=`grep homelamp1204 /home/$APACHE_USER/.bashrc 2>&1`
if [[ $checkhomelamp == "" ]]; then
echo "source $DOCKER_DIR/conf/bashrc/homelamp1204.txt" >> /home/$APACHE_USER/.bashrc
fi

chown $APACHE_USER.$APACHE_GROUP $WORKDIR
chown $APACHE_USER.$APACHE_GROUP $WORKDIR
fi

if [[ $APACHE_CHANGEUSER != "" ]]; then
find $WORKDIR -type f | xargs chmod 664
find $WORKDIR -type d | xargs chmod 775
    if [[ $APACHE_USER != "" ]]; then
    chown -R $APACHE_USER $WORKDIR
    chown -R $APACHE_USER /opt
    fi
    if [[ $APACHE_GROUP != "" ]]; then
    chgrp -R $APACHE_GROUP $WORKDIR
    chgrp -R $APACHE_GROUP /opt
    fi
fi

sed -i -e"s/ports.conf/ports.conf\nInclude \/docker\/conf\/apache\/ports1204.conf/" /etc/apache2/apache2.conf
sed -i -e"s/APACHE_RUN_USER=www-data/APACHE_RUN_USER=$APACHE_USER/" /etc/apache2/envvars
sed -i -e"s/APACHE_RUN_GROUP=www-data/APACHE_RUN_GROUP=$APACHE_GROUP/" /etc/apache2/envvars
