#!/bin/bash

PUBLIC=$(pwd)"/public.sh"
if [[ ! -f "$PUBLIC" ]];then
    echo "[ERROR] Shell script, $PUBLIC, do not exist. This script exit! [ERROR] "
    exit
fi
source "$PUBLIC"

PACKAGE="nginx-1.22.0.tar.gz"
IP="http://nginx.org/download/"

splitline "*"
echo "[INFO] Input params { url : $IP, package : $PACKAGE} [INFO]"

download $IP $PACKAGE
if [[ $? -eq 0 ]];then
    # echo "error occurs during downloading!"
    splitline "*"
fi
untarPackage "$PACKAGE"
if [[ $? -eq 0 ]];then
    splitline "*"
fi
