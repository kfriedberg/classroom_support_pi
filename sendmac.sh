#!/bin/bash

[[ -f classroom_support_pi.conf ]] && . classroom_support_pi.conf || echo "classroom_support_pi.conf not found, please copy it from classroom_support_pi.conf.example"

MAC=$(ip -o link show dev eth0 | grep -Po 'ether \K[^ ]*')
IP=$(hostname -I)
echo "$MAC"
curl "$HOST/webservice/rest/server.php" -d"wstoken=$TOKENwsfunction=sshd_get_raspberry_pi&mac=$MAC&ip=$IP"
