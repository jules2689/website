Personal Website
=== 

Written in Rails, this encompasses my blog and interests.

## Setup

1. Requires Postgres
2. `bundle install` from the root directory, then `bin/rake db:create db:migrate`
3. Setup `config/secrets.yml`. Don't worry it's gitignored. Make sure to fill out default with your information.
```
  default: &default
    git_user: jules2689
    twitter_user: jules2689
    website_tagline: I am a production engineer at <a href="http://shopify.com">Shopify.</a> I work on Mobile Infrastructure.
    linkedin_url: http://www.linkedin.com/pub/julian-nadeau/49/1b0/721
    git_cdn_repo: jules2689/gitcdn
    git_cdn_repo_url: https://jules2689.github.io/gitcdn/
    website_title: Julian Nadeau
    website_email: julian@jnadeau.ca
    theme: theme_1

  development:
    <<: *default
    secret_key_base: KEY

  test:
    <<: *default
    secret_key_base: KEY

  production:
    <<: *default
    secret_key_base: KEY
    github_key: KEY
    devise_secret: KEY
    pg_db_name: KEY
    pg_user: KEY
    pg_pass: KEY
    google_analytics: UA-xxx-x
```
4. Create a user manually. This is a personal website, so there are no registrations.
5. All setup with Capistrano. Use `cap production deploy` to deploy (setting proper IPs in `deploy.rb`)
6. Use `cap production setup` to copy the secrets.yml file to the server
7. Make sure you have a `gitcdn`. This should be [this repo](https://github.com/jules2689/gitcdn), please remove the images from mine!

## How to Interests work?

Given a URL, `document_profile` on `interest` will parse through `config/supported_documents.yml` to find a matching website. It will then store the information from that website type in the record, but will default to "website".

It will pull the title from the website and take a screenshot of the page if it is not an embed. If it is an embed, it will form an embed link for use instead.
