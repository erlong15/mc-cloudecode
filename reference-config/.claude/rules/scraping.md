---
paths:
  - "tools/catalog-parser/**"
  - "services/**/Console/Commands/Parse*.php"
---

# Catalog parser rules

The parser is a local development tool. It collects public catalog metadata
to fill a local database during development and demos.

## Fetching discipline

- Check and respect `robots.txt` before fetching anything.
- Rate-limit requests: at most one request per second, with retry and backoff
  on 429 and 5xx responses.
- Send a descriptive `User-Agent` identifying the tool and its purpose.
- Fetch through the application's HTTP client, not through shell commands.
- Cache responses locally so a repeated run does not re-fetch the same pages.
- Stop on the first sustained error instead of hammering the source.

## Data handling

- Output goes to `storage/catalog/*.json`, which is git-ignored.
  Parsed third-party content is never committed to this repository.
- Extract structural metadata only: title, author name, genre, series, tags,
  price, rating. Do not store cover images or full annotation text.
- The committed seeder uses synthetic data and must work without the parser,
  so that anyone cloning the repository can run the project.
- The parser fills a local database on top of that baseline; it is optional.

## Code

- The parser is a console command with explicit arguments: source, page limit,
  output path.
- Parsing selectors live in one place and are documented — external markup
  changes, and this is the file that will need updating.
- Cover failure paths with tests using stored HTML fixtures, not live requests.
