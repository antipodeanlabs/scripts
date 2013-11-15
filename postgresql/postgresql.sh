set -e

cat <<EOF > /tmp/pgdg.list
deb http://apt.postgresql.org/pub/repos/apt/ precise-pgdg main
EOF

cat <<EOF > /tmp/locale
LANG="en_US.UTF-8"
EOF

sudo bash <<EOF
mv /tmp/pgdg.list /etc/apt/sources.list.d/pgdg.list
mv /tmp/locale /etc/default/locale

wget --quiet -O - http://apt.postgresql.org/pub/repos/apt/ACCC4CF8.asc | sudo apt-key add -
apt-get update
apt-get -y install postgresql-9.3 pgadmin3

ufw allow 5432
ufw --force enable

service postgresql restart
su postgres -c "psql -c \"ALTER USER postgres PASSWORD 'postgres';\""
EOF
