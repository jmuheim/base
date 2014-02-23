# Base Project

[![Code Climate](https://codeclimate.com/github/jmuheim/base.png)](https://codeclimate.com/github/jmuheim/base)
[![Travis CI](https://api.travis-ci.org/jmuheim/base.png)](https://travis-ci.org/jmuheim/base)
[![Dependency Status](https://gemnasium.com/jmuheim/base.png)](https://gemnasium.com/jmuheim/base)
[![Coverage Status](https://coveralls.io/repos/jmuheim/base/badge.png)](https://coveralls.io/r/jmuheim/base)

This is a basic Rails project with everything configured the way I want. Fork it to create new projects out of it.

## Developer Environment

- [Mac OS X](http://www.apple.com/osx/)
- [POW](http://pow.cx/)
- [Git](http://git-scm.com/)
- [Google Chrome](https://www.google.com/intl/en/chrome/browser/)

## How to develop

### Checkout and configure

- `$ git clone git@github.com:jmuheim/base.git`
- `$ cd base`
- `$ bundle install`
- `$ powder install`
- `$ powder link`

### Developing

- `$ powder open` opens [http://base.dev/](http://base.dev/) in the browser.
- `$ guard` starts Guard, which takes care about executing tests (using [Spring application preloader](https://github.com/jonleighton/spring)), live reloading of the page, etc.
- Use `binding.remote_pry` to set a breakpoint in code that is executed by the `POW` service and connect to it using `pry-remote` from the console.
- Use `binding.pry` to set a breakpoint in code that is run through an active console (e.g. `guard` or `rails s`)
- Execute `$ rip_hashrockets` from time to time to replace old Ruby hashrockets (`=>`) with the new syntax.

### Testing

- Use `@chrome` or `@selenium` flag to visually run acceptance tests in Chrome or Firefox.

## Deploying

- Run `rake HEADHUNTER=true` to make sure all HTML and CSS is valid.

### Travis CI

- Project is configured to be continuously integrated using [Travis CI](https://travis-ci.org/jmuheim/base).

## Backlog

You can find the backlog here: [`BACKLOG.md`](./BACKLOG.md).
