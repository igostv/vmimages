#!/bin/bash
#set -x

if [ -z "$V8USER" ]
then
    echo "USERNAME not set"
    exit 1
fi

if [ -z "$V8PASSW" ]
then
    echo "PASSWORD not set"
    exit 1
fi

V8VERSION="$1"
DOWNLOADIR="$2"

if [ -z "$V8VERSION" ]
then
    echo "VERSION not set"
    exit 1
fi

SRC=$(curl -c /tmp/cookies.txt -s -L https://releases.1c.ru)
ACTION=$(echo "$SRC" | grep -oP '(?<=form method="post" id="loginForm" action=")[^"]+(?=")') 
#LT=$(echo "$SRC" | grep -oP '(?<=input type="hidden" name="lt" value=")[^"]+(?=")')
EXECUTION=$(echo "$SRC" | grep -oP '(?<=input type="hidden" name="execution" value=")[^"]+(?=")')

curl -s -L \
    -o /dev/null \
    -b /tmp/cookies.txt \
    -c /tmp/cookies.txt \
    --data-urlencode "inviteCode=" \
    --data-urlencode "geolocation=" \
    --data-urlencode "execution=$EXECUTION" \
    --data-urlencode "_eventId=submit" \
    --data-urlencode "username=$V8USER" \
    --data-urlencode "password=$V8PASSW" \
    https://login.1c.ru"$ACTION"

if ! grep -q "userSettings" /tmp/cookies.txt
then
    echo "Auth failed"
    exit 1
fi

texttodownload="Скачать дистрибутив"

CLIENTLINK=$(curl -s -G \
    -b /tmp/cookies.txt \
    --data-urlencode "nick=Platform83" \
    --data-urlencode "ver=$V8VERSION" \
    --data-urlencode "path=Platform\\${V8VERSION//./_}\\windows.rar" \
    https://releases.1c.ru/version_file | grep -oP "(?<=a href=\")[^\"]+(?=\">$texttodownload)")
echo $CLIENTLINK

mkdir -p $DOWNLOADIR

curl -L -b /tmp/cookies.txt -o $DOWNLOADIR/windows.rar "$CLIENTLINK"

rm /tmp/cookies.txt