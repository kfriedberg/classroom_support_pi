#!/bin/bash

SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
SOURCEDIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"

apt-get -y install unclutter

# autostart
mkdir -p /home/$SUDO_USER/.config/autostart/
echo [Desktop Entry] > /home/$SUDO_USER/.config/autostart/classroom_support_pi.desktop
echo Type=Application >> /home/$SUDO_USER/.config/autostart/classroom_support_pi.desktop
echo Name=Classroom support Pi >> /home/$SUDO_USER/.config/autostart/classroom_support_pi.desktop
echo Exec=/bin/bash $SOURCEDIR/autostart_helper.sh >> /home/$SUDO_USER/.config/autostart/classroom_support_pi.desktop
chmod +x /home/$SUDO_USER/.config/autostart/classroom_support_pi.desktop
chmod +x autostart_helper.sh

# allow reboot over SSH
mkdir -p /etc/polkit-1/rules.d
ln -sf $SOURCEDIR/10-nopasswd_sudo_grp_reboot.rules /etc/polkit-1/rules.d/10-nopasswd_sudo_grp_reboot.rules

# require password for sudo operations
ln -sf $SOURCEDIR/020_sudo-grp-passwd-override /etc/sudoers.d/020_sudo-grp-passwd-override

# heartbeat
echo "*/5 * * * * root /bin/bash $SOURCEDIR/sendmac.sh" > classroom_support_cronjob
chmod +x sendmac.sh
ln -sf $SOURCEDIR/classroom_support_cronjob /etc/cron.d/classroom_support_cronjob
chown root: *

# wait for network at boot
mkdir -p /etc/systemd/system/dhcpcd.service.d/
echo [Service] > /etc/systemd/system/dhcpcd.service.d/wait.conf
echo ExecStart= >> /etc/systemd/system/dhcpcd.service.d/wait.conf
echo ExecStart=/usr/sbin/dhcpcd -w -q >> /etc/systemd/system/dhcpcd.service.d/wait.conf

# firewall
apt-get -y install ufw
ufw allow ssh
ufw enable

systemctl enable ssh
systemctl start ssh
