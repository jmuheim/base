# TITLE

TODO: Add badges!

## Setting up project locally

Live project: [ACCOUNT.SERVER.uberspace.de](http://ACCOUNT.SERVER.uberspace.de)

Recommended environment:

- [Mac OS X](http://www.apple.com/osx/)
- [Git](http://git-scm.com/)
- [Google Chrome](https://www.google.com/intl/en/chrome/browser/)

Setup:

- `$ git clone git@github.com:GITHUB/PROJECT.git`
- `$ cd PROJECT`
- `$ bundle install`
- `$ cp config/secrets.example.yml config/secrets.yml`
- Open `config/secrets.yml` and edit it
- `$ rails db:setup`
- `$ rails db:test:prepare`

You can use [direnv](https://github.com/zimbatm/direnv) to automatically add `bin` to your `$PATH`. Otherwise you should always use `bundle exec` to run commands.

## Requirements

- [Pandoc](http://pandoc.org/) for advanced Markdown capabilities: `$ brew install pandoc`
- [ImageMagick](http://imagemagick.org/) for image manipulation: `$ brew install imagemagick`

## Developing

- In one terminal, enter `$ server` to start the development server using [rerun](https://github.com/alexch/rerun) (which will take care of restarting the server upon changes of important config files)
- In a second terminal, enter `$ guard` to start Guard, which automatically takes care of:
    - executing tests using [Guard-RSpec](https://github.com/guard/guard-rspec)
    - live reloading the page (HTML, JS and CSS) using [Guard-LiveReload](https://github.com/guard/guard-livereload)
    - bundling using [Guard-Bundler](https://github.com/guard/guard-bundler)
    - annotating models using [Guard-Annotate](https://github.com/cpjolicoeur/guard-annotate)
    - migrating the DB using [Guard-Migrate](https://github.com/glanotte/guard-migrate)
- Open [http://localhost:PORT](http://localhost:PORT) in your browser (use whatever port you specified in `config/boot.rb`)

### Before merging a pull request

Make sure that:

- All authorization is done through [cancancan](https://github.com/CanCanCommunity/cancancan)
- The [ability.rb](./app/models/ability.rb) file is thoroughly tested
- Every action has a correlating feature spec file (nest them in folders similar to the nested routes' structure)
- Every navigation item has a correlating spec in [navigation_spec.rb](./spec/features/navigation_spec.rb)
- Run `$ i18n-tasks normalize`
- Run `$ rake` and make sure, no specs are pending/failing

### I18n

The [i18n-tasks](https://github.com/glebm/i18n-tasks) gem makes handling translations easily. It helps finding unused and not yet translated keys, and normalizes (e.g. sorts) the translation files.

- `$ i18n-tasks normalize`, then commit
- `$ i18n-tasks unused`, then remove unused keys and commit
- `$ i18n-tasks add-missing -v 'TRANSLATE: %{value}'`, then translate everything (do a project search for `TRANSLATE:`) and commit

## Testing

- Use `driver: :chrome` to visually run feature tests in Chrome.

## Deployment

### Setup

To learn more about setting up deployment on a server, see [Deployment](./DEPLOYMENT.md).

### Deploying

Be sure you have committed and pushed all wanted changes, then execute `$ cap production deploy`.

That's all, folks!
