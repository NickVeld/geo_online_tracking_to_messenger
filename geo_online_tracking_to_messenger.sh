#!/usr/bin/env bash

#   Copyright 2024 Ni.Ve.
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0

set -e

echo "WARNING: Before deleting last_message_id, delete the message or you won't be able to clean it after"


# Does not work: IFS=$'\n' / IFS='*manual_new_linw*'/ IFS=$(echo -e '\n') read -rd ''
read -r http_method url_relative_reference http_protocol

message_to_send=$(
  echo "${url_relative_reference}" \
  | sed -r 's|.*lat=([0-9]*\.[0-9]*)&lon=([0-9]*\.[0-9]*)&timestamp=([0-9]*).*|echo $(date) https%3A%2F%2Fwww.openstreetmap.org%2F%3Fmlat%3D\1%26mlon%3D\2%26zoom%3D16|'
)
# https://www.openstreetmap.org/?mlat=\1\&mlon=\2\&zoom\=16

# Transforms date in human readable format and then (together with map URL into URL-encoded string)
message_to_send=$(eval "${message_to_send}" | sed 's| |+|g' | sed 's|:|%3A|g' )

external_host="api.telegram.org"
external_token=$(cat telegram_token.txt)
external_recipient=$(cat telegram_recipient.txt)
if [ -f last_message_id.tmp ]; then
  last_message_id=$(cat last_message_id.tmp)
  # https://core.telegram.org/bots/api#editmessagetext
  external_url_relative_reference="/bot${external_token}/editMessageText?text=${message_to_send}&chat_id=${external_recipient}&message_id=${last_message_id}"
else
  # https://core.telegram.org/bots/api#sendmessage
  external_url_relative_reference="/bot${external_token}/sendMessage?text=${message_to_send}&chat_id=${external_recipient}"
fi

external_response=$(
  curl -L "https://${external_host}${external_url_relative_reference}"
)

if [ ! -f last_message_id.tmp ]; then
  echo "${external_response}" | tr '\n' ' ' | sed -r 's|.*"message_id":([0-9]*),.*|\1|' > last_message_id.tmp
fi

echo "${external_response}"
