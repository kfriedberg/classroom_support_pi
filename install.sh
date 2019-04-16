#!/bin/bash

CURRENTDIR=`dirname "$0"`

apt-get -y install unclutter

mkdir -p /home/pi/.config/lxsession/LXDE-pi
ln -s $CURRENTDIR/autostart /home/pi/.config/lxsession/LXDE-pi/autostart

mkdir -p /etc/polkit-1/localauthority/50-local.d
ln -s $CURRENTDIR/10-nopasswd_pi_reboot.pkla /etc/polkit-1/localauthority/50-local.d/10-nopasswd_pi_reboot.pkla

mkdir -p /etc/polkit-1/rules.d
ln -s $CURRENTDIR/10-nopasswd_pi_reboot.rules /etc/polkit-1/rules.d/10-nopasswd_pi_reboot.rules

ln -s $CURRENTDIR/020_pi-passwd-override /etc/sudoers.d/020_pi-passwd-override

echo */5 * * * * pi $CURRENTDIR/sendmac.sh > classroom_support-cronjob
chmod a+x sendmac.sh

ln -s ./classroom_support-cronjob /etc/cron.d/classroom_support-cronjob

chown root: *

systemctl enable ssh
systemctl start ssh
