# TITLE

## Setting up project locally

Recommended environment:

- [Mac OS X](http://www.apple.com/osx/)
- [Git](http://git-scm.com/)
- [Google Chrome](https://www.google.com/intl/en/chrome/browser/)

- `$ git clone git@github.com:jmuheim/PROJECT.git`
- `$ cd PROJECT`
- `$ bundle install`
- Change the value of `Port:` in `config/boot.rb` to e.g. `3002`
- Change the value of `port:` in `Guardfile` and the value of `live_reload_port:` in `config/environments/development.rb` to e.g. `357230`.

You can use [direnv](https://github.com/zimbatm/direnv) to automatically add `bin` to your `$PATH`. Otherwise you should always use `bundle exec` to run commands.

## Developing

- In one terminal, enter `$ server` to start the development server using [rerun](https://github.com/alexch/rerun) (which will take care of restarting the server upon changes of important config files)
- In a second terminal, enter `$ guard` to start Guard, which automatically takes care of:
  - executing tests using [Guard-RSpec](https://github.com/guard/guard-rspec)
  - live reloading the page (HTML, JS and CSS) using [Guard-LiveReload](https://github.com/guard/guard-livereload)
  - bundling using [Guard-Bundler](https://github.com/guard/guard-bundler)
  - annotating models using [Guard-Annotate](https://github.com/cpjolicoeur/guard-annotate)
  - migrating the DB using [Guard-Migrate](https://github.com/glanotte/guard-migrate)
- Execute `$ rip_hashrockets` from time to time to replace old Ruby hashrockets (`=>`) with the new syntax

## Testing

- Use `@chrome` or `@selenium` flag to visually run feature tests in Chrome or Firefox.

## Deployment

### Setup

To learn more about setting up deployment on a server, see [Deployment](./DEPLOYMENT.md).

### Deploying

**Before deploying**, run `rake HEADHUNTER=true` to make sure all HTML and CSS is in good shape!

Be sure you have committed and pushed all wanted changes, then execute `$ mina deploy`! Use the `--verbose` and `--trace` switch for debugging if something goes wrong.

That's all, folks!

## Continuous integration

- The project is configured to be continuously integrated using [Travis CI](https://travis-ci.org/jmuheim/PROJECT) (`master` branch only).

## Backlog

You can find the backlog here: [`BACKLOG.md`](./BACKLOG.md).
