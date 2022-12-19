#!/bin/bash

# Based on existing Zendesk subdomains and languages, try to fetch all un-fetched articles

find *.zendesk.com -mindepth 1 -maxdepth 1 -type d | sed 's/\.zendesk.com\// /' | xargs --verbose -L1 ./scripts/update_articles.sh

# Prettify all article JSON, for better diff
./scripts/prettify_all.sh

