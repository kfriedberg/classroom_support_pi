#!/bin/bash

SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
SOURCEDIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"

[[ -f $SORUCEDIR/classroom_support_pi.conf ]] && . $SOURCEDIR/classroom_support_pi.conf || echo "classroom_support_pi.conf not found, please copy it from classroom_support_pi.conf.example"

MAC=$(ip -o link show dev eth0 | grep -Po 'ether \K[^ ]*')
IP=$(hostname -I)
echo "$MAC"
curl "$HOST/webservice/rest/server.php" -d"wstoken=$TOKEN&wsfunction=sshd_get_raspberry_pi&mac=$MAC&ip=$IP"
