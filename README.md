Personal Website
=== 

Written in Rails, this encompasses my blog and interests.

## Setup

1. Requires Postgres
2. `bundle install` from the root directory
3. Setup 'config/secrets.yml'. Don't worry it's gitignored.
```
  development:
    secret_key_base: KEY

  test:
    secret_key_base: KEY

  production:
    secret_key_base: KEY
    github_key: KEY
    devise_secret: KEY
    pg_db_name: KEY
    pg_user: KEY
    pg_pass: KEY
```
4. All setup with Capistrano. Use `cap production deploy` to deploy (setting proper IPs in `deploy.rb`)
5. Use `cap production setup` to copy the secrets.yml file to the server

## How to Interests work?

Given a URL, `document_profile` on `interest` will parse through `config/supported_documents.yml` to find a matching website. It will then store the information from that website type in the record, but will default to "website".

It will pull the title from the website and take a screenshot of the page if it is not an embed. If it is an embed, it will form an embed link for use instead.
