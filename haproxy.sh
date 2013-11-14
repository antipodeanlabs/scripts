set -e

cat <<EOF > /tmp/haproxy.conf
if ($programname == 'haproxy') then -/var/log/haproxy.log
EOF

cat <<EOF > /tmp/rsyslog-udp.conf
$ModLoad imudp
$UDPServerAddress 127.0.0.1
$UDPServerRun 514
EOF

sudo bash <<EOF
apt-get update
apt-get -y install haproxy

ufw allow www
ufw allow 9000
ufw --force enable

sed 's/ENABLED=0/ENABLED=1/' -i /etc/default/haproxy

mv /tmp/haproxy.conf /etc/rsyslog.d/haproxy.conf
mv /tmp/rsyslog-udp.conf /etc/rsyslog.d/rsyslog-udp.conf

service rsyslog restart
service haproxy start
EOF