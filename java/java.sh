set -e

sudo bash <<EOF
mkdir -p /usr/lib/jvm/
wget -O /tmp/jre-7u45-linux-x64.tar.gz --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com" \
  http://download.oracle.com/otn-pub/java/jdk/7u45-b18/jre-7u45-linux-x64.tar.gz
tar -xvf /tmp/jre-7u45-linux-x64.tar.gz -C /usr/lib/jvm/
update-alternatives --install /usr/bin/java java /usr/lib/jvm/jre1.7.0_45/bin/java 1
update-alternatives --set java /usr/lib/jvm/jre1.7.0_45/bin/java
EOF