#!/bin/bash

if (( $# != 4 )); then
  echo invalid args, required 4 args
  exit
fi

if [[ ! $1 =~ ^202[0-9]-[0-9]{2}-[0-9]{2}$ ]]; then
  echo invalid date: $1
  exit
fi

do_date=$1
startup_count=$2
maxmid=$3
maxuid=$4

for ip in doug-hadoop{101,102}
do
  ssh -T $ip <<EOF
  cd /usr/local/applog
  sed -i "s/^mock\.date=.*/mock.date=$do_date/" application.properties
  sed -i "s/^mock\.startup\.count=.*/mock.startup.count=$startup_count/" application.properties
  sed -i "s/^mock\.max\.mid=.*/mock.max.mid=$maxmid/" application.properties
  sed -i "s/^mock\.max\.uid=.*/mock.max.uid=$maxuid/" application.properties
EOF
done

lg.sh force
f1.sh start
f2.sh start
