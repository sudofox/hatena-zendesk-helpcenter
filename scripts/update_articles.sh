#!/bin/bash

# fetch https://hatena.zendesk.com/api/v2/help_center/ja/articles.json and then, as long as the response has a "next_page" key, fetch that page and append the results to the current results. then, for each id, append data/article_ids.txt

# get the first page
PAGE=0
NEED_MORE=true
ARTICLE_IDS=""
RATELIMIT_MESSAGE="Number of allowed API requests per minute exceeded"

while [[ "$NEED_MORE" == "true" ]]; do
  PAGE=$((PAGE + 1))
  echo "Fetching page $PAGE" >&2
  PAGE_DATA=$(curl -s "https://hatena.zendesk.com/api/v2/help_center/ja/articles.json?per_page=100&page=$PAGE")

  if [[ "$(echo "$PAGE_DATA" | grep -Po "$RATELIMIT_MESSAGE" | wc -l)" == "1" ]]; then
    echo "Rate limit exceeded" >&2
    exit 1
  fi
  # use jq to check if .next_page is null
  if [[ "$(echo "$PAGE_DATA" | jq -r '.next_page')" == "null" ]]; then
    NEED_MORE=false
  fi
  # for each entry in .articles, get the id and append it to ARTICLE_IDS
  ARTICLE_IDS="$ARTICLE_IDS"$'\n'"$(echo "$PAGE_DATA" | jq -r '.articles[].id')"
done

echo "$ARTICLE_IDS" | sort -u >> data/article_ids.txt
# idk if articles will go unlisted but just in case we're going to append and then remove duplicates
sort -u data/article_ids.txt -o data/article_ids.txt

# for each id in data/article_ids.txt, fetch the article and write it to data/articles/<id>.json
while read -r id; do
  # if blank line, skip
  if [[ "$id" == "" ]]; then
    continue
  fi

  # if the file already exists, skip
  if [[ -f "data/articles/$id.json" ]]; then
    echo "Skipping article $id (already exists)" >&2
    continue
  fi

  echo "Fetching article $id" >&2
  ARTICLE=$(curl -s "https://hatena.zendesk.com/api/v2/help_center/ja/articles/$id.json")
  # check if the body says 'Number of allowed API requests per minute exceeded' (not jq)
  if [[ "$(echo "$ARTICLE" | grep -Po "$RATELIMIT_MESSAGE" | wc -l)" == "1" ]]; then
    echo "API rate limit exceeded" >&2
    exit 1
  fi

  echo -n "$ARTICLE" > "data/articles/$id.json"
done < data/article_ids.txt