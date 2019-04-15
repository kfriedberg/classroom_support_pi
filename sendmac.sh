#!/bin/bash

. classroom_support_pi.conf

MAC=$(ip -o link show dev eth0 | grep -Po 'ether \K[^ ]*')
IP=$(hostname -I)
echo "$MAC"
curl "$HOST/webservice/rest/server.php" -d"wstoken=$TOKENwsfunction=sshd_get_raspberry_pi&mac=$MAC&ip=$IP"
