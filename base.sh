set -e

sudo bash <<EOF
apt-get -y upgrade
apt-get update
apt-get -y install ntp

ufw allow ssh
ufw allow ntp
ufw logging on
ufw --force enable
EOF