# Base Project

[![Code Climate](https://codeclimate.com/github/jmuheim/base.png)](https://codeclimate.com/github/jmuheim/base)
[![Travis CI](https://api.travis-ci.org/jmuheim/base.png)](https://travis-ci.org/jmuheim/base)
[![Dependency Status](https://gemnasium.com/jmuheim/base.png)](https://gemnasium.com/jmuheim/base)
[![Coverage Status](https://coveralls.io/repos/jmuheim/base/badge.png)](https://coveralls.io/r/jmuheim/base)

## Developer Environment

- [Mac OS X](http://www.apple.com/osx/)
- [Git](http://git-scm.com/)
- [Google Chrome](https://www.google.com/intl/en/chrome/browser/) (has the best developer tools)

## How to develop

### Checkout and configure

- `$ git clone git@github.com:jmuheim/base.git`
- `$ cd base`
- `$ bundle install`
- Change the value of `Port:` in `config/boot.rb` to e.g. `3002`
- Change the value of `port:` in `Guardfile` and the value of `live_reload_port:` in `config/environments/development.rb` to e.g. `357230`.

You can use [direnv](https://github.com/zimbatm/direnv) to automatically add `bin` to your `$PATH`. Otherwise you should always use `bundle exec` to run commands.

### Developing

- In one terminal, enter `$ rails s -p 3001` to start the development server on port 3001
- In a second terminal, enter `$ guard` to start Guard, which automatically takes care of:
  - executing tests using [Guard-RSpec](https://github.com/guard/guard-rspec)
  - live reloading the page (HTML, JS and CSS) using [Guard-LiveReload](https://github.com/guard/guard-livereload)
  - bundling using [Guard-Bundler](https://github.com/guard/guard-bundler)
  - annotating models using [Guard-Annotate](https://github.com/cpjolicoeur/guard-annotate)
  - migrating the DB using [Guard-Migrate](https://github.com/glanotte/guard-migrate)
  - restarting development server using [Guard-Shell](https://github.com/hawx/guard-shell)
- Execute `$ rip_hashrockets` from time to time to replace old Ruby hashrockets (`=>`) with the new syntax

### Testing

- Use `@chrome` or `@selenium` flag to visually run acceptance tests in Chrome or Firefox.

## Deploying

- **Before deploying**, run `rake HEADHUNTER=true` to make sure all HTML and CSS is in good shape.

### Travis CI

- Project is configured to be continuously integrated using [Travis CI](https://travis-ci.org/jmuheim/base).

## Backlog

You can find the backlog here: [`BACKLOG.md`](./BACKLOG.md).
