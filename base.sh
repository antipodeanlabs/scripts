set -e

sudo bash <<EOF
apt-get update
sudo apt-get -y install ntp

ufw allow ssh
ufw allow ntp
ufw logging on
ufw --force enable
EOF