#!/bin/bash

apt-get -y update

# Installation de certains packages forts utiles.
apt-get install -y curl vim

dpkg -l | grep apache2
if ! [ $? -eq 0 ]
then
    apt-get -y install apache2
    /etc/init.d/apache2 start
    echo "Installation d'Apache faite ..."
fi

dpkg -l | grep elasticsearch
if ! [ $? -eq 0 ]
then
    apt-get -y install openjdk-7-jre

    wget https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.2.1.deb
    dpkg -i elasticsearch-1.2.1.deb

    update-rc.d elasticsearch defaults 95 10
    /etc/init.d/elasticsearch start
    echo "Installation d'Elasticsearch faite ..."
fi

test -L /opt/logstash
if ! [ $? -eq 0 ]
then
    cd /opt
    wget https://download.elasticsearch.org/logstash/logstash/logstash-1.4.1.tar.gz
    tar xzf logstash-1.4.1.tar.gz -C /opt/
    ln -sf logstash-1.4.1 logstash
    #cd /vagrant_data/scripts
    #sh logstash.sh start
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
