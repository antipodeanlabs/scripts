set -e

cat <<EOF > /tmp/max.limits.conf
* soft nofile 32768
* hard nofile 32768
root soft nofile 32768
root hard nofile 32768
* soft memlock unlimited
* hard memlock unlimited
root soft memlock unlimited
root hard memlock unlimited
* soft as unlimited
* hard as unlimited
root soft as unlimited
root hard as unlimited
EOF

sudo bash <<EOF
mv /tmp/max.limits.conf /etc/security/limits.d/max.limits.conf
sysctl -w vm.max_map_count=131072
echo "vm.max_map_count = 131072" >> /etc/security/limits.conf
EOF
