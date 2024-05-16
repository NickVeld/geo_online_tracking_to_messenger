#!/usr/bin/env bash

#   Copyright 2024 Ni.Ve.
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0

SECONDS_TO_SLEEP=60
while : ; do
  ncat -l localhost "${PORT_TO_LISTEN}" | /usr/bin/env bash geo_online_tracking_to_messenger.sh
  SECONDS_START="${SECONDS}"
  while [ "$((${SECONDS} - ${SECONDS_START}))" -lt "${SECONDS_TO_SLEEP}" ] ; do
    ncat -l localhost "${PORT_TO_LISTEN}" > /dev/null
  done
done
