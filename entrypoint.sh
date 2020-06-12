#!/bin/sh
set -e

[[ $DEBUG == true ]] && set -x

env

myextip=$(curl http://ipv4.icanhazip.com)
thedate=$(date +"%X %x %Z")
myenv=$thisenv

echo ${thisenv}
echo ${myenv}

sed -i "s/thisextip/${myextip}/" /etc/nginx/nginx.conf
sed -i "s|deploydate|${thedate}|" /etc/nginx/nginx.conf
sed -i "s/thisenv/${myenv}/" /etc/nginx/nginx.conf

echo $thedate
echo ${myextip}
echo "THe env is ${myenv}"
cat /etc/nginx/nginx.conf | tee

# default behaviour is to launch nginx
if [[ -z ${1} ]]; then
  echo "Starting nginx..."
  exec $(which nginx) -c /etc/nginx/nginx.conf -g "daemon off;"
else
  exec "$@"
fi

