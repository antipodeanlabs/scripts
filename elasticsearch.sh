set -e

sudo bash <<EOF
apt-get update
apt-get -y install python-pip

wget -O /tmp/elasticsearch-0.90.5.deb https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-0.90.5.deb
dpkg -i /tmp/elasticsearch-0.90.5.deb

/usr/share/elasticsearch/bin/plugin --install elasticsearch/elasticsearch-cloud-aws/1.15.0
service elasticsearch restart

ufw allow 9200
ufw allow 54328
ufw --force enable
EOF
