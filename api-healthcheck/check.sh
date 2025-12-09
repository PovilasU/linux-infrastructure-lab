#!/bin/bash

URL="http://localhost/health/health.php"
STATUS=$(curl -s $URL | jq -r '.status')

if [ "$STATUS" != "OK" ]; then
    echo "$(date) - ERROR: Healthcheck returned $STATUS"
else
    echo "$(date) - OK"
fi

