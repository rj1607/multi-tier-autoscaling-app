#!/bin/bash

HOST=$1
PORT=$2

echo "Waiting for Amazon RDS..."

until nc -z $HOST $PORT
do
    echo "RDS not ready..."
    sleep 5
done

echo "Amazon RDS is Ready."