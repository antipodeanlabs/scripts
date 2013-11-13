set -e

declare -a users=(stuartrexking marksievers)

for user in "${users[@]}"
do
sudo bash <<EOF
useradd -s /bin/bash -d /home/$user -m $user
adduser $user sudo
echo "$user ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/$user
mkdir /home/$user/.ssh
wget -O /home/$user/.ssh/authorized_keys https://github.com/$user.keys
chown -R $user:$user /home/$user/.ssh
chmod 0700 /home/$user/.ssh
chmod 0600 /home/$user/.ssh/authorized_keys
EOF
done
