#!/bin/bash

SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
CURRENTDIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"

apt-get -y install unclutter

mkdir -p /home/pi/.config/lxsession/LXDE-pi
ln -sf $CURRENTDIR/autostart /home/pi/.config/lxsession/LXDE-pi/autostart

mkdir -p /etc/polkit-1/localauthority/50-local.d
ln -sf $CURRENTDIR/10-nopasswd_pi_reboot.pkla /etc/polkit-1/localauthority/50-local.d/10-nopasswd_pi_reboot.pkla

mkdir -p /etc/polkit-1/rules.d
ln -sf $CURRENTDIR/10-nopasswd_pi_reboot.rules /etc/polkit-1/rules.d/10-nopasswd_pi_reboot.rules

ln -sf $CURRENTDIR/020_pi-passwd-override /etc/sudoers.d/020_pi-passwd-override

echo "*/5 * * * * pi $CURRENTDIR/sendmac.sh" > classroom_support_cronjob
chmod a+x sendmac.sh

ln -sf $CURRENTDIR/classroom_support_cronjob /etc/cron.d/classroom_support_cronjob

chown root: *

systemctl enable ssh
systemctl start ssh
