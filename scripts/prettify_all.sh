#!/bin/bash

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

# find all directories that have a .zendesk.com directory in them, find all .json files, and use jq to pretty-print them, overwriting the original file
find *.zendesk.com -type f -name "*.json" -exec bash -c 'jq . "$0" > "$0.tmp" && mv "$0.tmp" "$0"' {} \;