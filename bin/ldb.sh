#!/bin/bash

if [[ ! $1 =~ ^202[0-9]-[0-9]{2}-[0-9]{2}$ ]]; then
  echo invalid date: $1
fi

for ip in doug-hadoop102
do
  ssh -T $ip <<EOF
  cd /usr/local/db_log
  sed -i "s/^mock\.date=.*/mock.date=$1/" application.properties
  sed -i "s/^mock\.clear=.*/mock.clear=0/" application.properties
  java -jar gmall2020-mock-db-2020-04-01.jar
EOF
done

