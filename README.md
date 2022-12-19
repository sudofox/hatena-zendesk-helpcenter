# sudofox/hatena-zendesk-helpcenter

An archived copy of Hatena's Zendesk help center articles, just in case they ever change or get removed.

There's a GH action to auto-update things.

## Scripts

- `./scripts/update_articles.sh` to pull latest data and download the articles (syntax: `update_articles.sh <subdomain before .> <locale code>`)
- `./scripts/update_all.sh` to check for any article data updates, new articles, etc, and to auto-format the article json for better diffing
- `./scripts/prettify_all.sh` to do the above auto-formatting as a standalone task

## Included help centers

- hatenablogmedia.zendesk.com
- hatena.zendesk.com
- mackerelio.zendesk.com (this is normally aliased as support.mackerel.io)
