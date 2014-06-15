#!/bin/bash

# Installation de certains packages forts utiles.
apt-get install -y curl vim

dpkg -l | grep apache2
if ! [ $? -eq 0 ]
then
    apt-get -y update
    apt-get -y install apache2
    /etc/init.d/apache2 start
    echo "Installation d'Apache faite ..."
fi

dpkg -l | grep elasticsearch
if ! [ $? -eq 0 ]
then
    #wget -O - http://packages.elasticsearch.org/GPG-KEY-elasticsearch | apt-key add -
    #echo "deb http://packages.elasticsearch.org/elasticsearch/1.2/debian stable main" >> /etc/apt/sources.list
    #apt-get -y update
    apt-get -y install openjdk-7-jre

    wget https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.2.1.deb
    dpkg -i elasticsearch-1.2.1.deb

    update-rc.d elasticsearch defaults 95 10
    /etc/init.d/elasticsearch start
    echo "Installation d'Elasticsearch faite ..."
fi

dpkg -l | grep logstash
if ! [ $? -eq 0 ]
then
    wget https://download.elasticsearch.org/logstash/logstash/packages/debian/logstash_1.4.1-1-bd507eb_all.deb
    dpkg -i logstash_1.4.1-1-bd507eb_all.deb
    cd /etc/logstash
    ln -sf /vagrant_data/conf/logstash/logstash.conf /etc/logstash/conf.d/logstash.conf
    update-rc.d logstash defaults
    /etc/init.d/logstash start
    echo "Installation de LogStash faite ..."
fi

test -d /var/www/kibana
if ! [ $? -eq 0 ]
then
    cd /tmp/
    wget https://download.elasticsearch.org/kibana/kibana/kibana-3.1.0.tar.gz
    tar xf kibana-3.1.0.tar.gz -C /var/www
    cd /var/www
    mv kibana-3.1.0 kibana
    echo "Installation de Kibana faite ..."
fi
