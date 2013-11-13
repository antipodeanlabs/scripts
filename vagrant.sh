set -e

sudo bash <<EOF
useradd -s /bin/bash -d /home/vagrant -m vagrant -p vagrant

mkdir -m 0711 /home/ubuntu/.ssh/
echo 'ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA6NF8iallvQVp22WDkTkyrtvp9eWW6A8YVr+kz4TjGYe7gHzIw+niNltGEFHzD8+v1I2YJ6oXevct1YeS0o9HZyN1Q9qgCgzUFtdOKLv6IedplqoPkcmF0aYet2PkEDo3MlTBckFXPITAMzF8dJSIFo9D8HfdOV0IAdx4O7PtixWKn5y2hMNG0zQPyUecp4pzC6kivAIhyfHilFR61RGL+GPXQ2MWZWFYbAGjyiYJnAmCP3NOTd0jMZEnDkbUvxhMmBYSdETk1rRgm+R4LOzFUGaHqHDLKLX+FIPKcF96hrucXzcWyLbIbEgE98OHlnVYCzRdK8jlqm8tehUc9c9WhQ== vagrant insecure public key' > /home/ubuntu/.ssh/authorized_keys

groupadd admin
usermod -G admin vagrant
echo '%admin ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers
echo 'UseDNS no' >> /etc/ssh/sshd_config
/etc/init.d/sudo restart

mkdir -p /home/vagrant/.ssh/
wget -O /home/vagrant/.ssh/vagrant http://github.com/mitchellh/vagrant/raw/master/keys/vagrant
wget -O /home/vagrant/.ssh/vagrant.pub http://github.com/mitchellh/vagrant/raw/master/keys/vagrant.pub
cat /home/vagrant/.ssh/vagrant.pub > /home/vagrant/.ssh/authorized_keys

apt-get -y install linux-headers-$(uname -r) dkms

mkdir /mnt/VBoxGuestAdditions
mount /home/ubuntu/VBoxGuestAdditions.iso /mnt/VBoxGuestAdditions
sh /mnt/VBoxGuestAdditions/VBoxLinuxAdditions.run

umount /mnt/VBoxGuestAdditions
rmdir /mnt/VBoxGuestAdditions
rm /home/ubuntu/VBoxGuestAdditions.iso

dd if=/dev/zero of=/EMPTY bs=1M
rm /EMPTY
EOF