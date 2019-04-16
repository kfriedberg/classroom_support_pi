#!/bin/bash

apt-get -y install unclutter

ln -s autostart /home/pi/.config/lxsession/LXDE-pi

ln -s 10-nopasswd_pi_reboot.pkla /etc/polkit-1/localauthority/50-local.d/10-nopasswd_pi_reboot.pkla

ln -s 10-nopasswd_pi_reboot.rules /etc/polkit-1/rules.d/10-nopasswd_pi_reboot.rules

ln -s 020_pi-passwd-override /etc/sudoers.d/020_pi-passwd-override

echo */5 * * * * pi `dirname "$0"`/sendmac.sh > classroom_support-cronjob
chmod a+x sendmac.sh

ln -s classroom_support-cronjob /etc/cron.d/classroom_support-cronjob

chown root: *

systemctl enable ssh
systemctl start ssh
