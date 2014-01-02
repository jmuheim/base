# Transition Net

## Developer Environment

- [Mac OS X](http://www.apple.com/osx/)
- [POW](http://pow.cx/)
- [Git](http://git-scm.com/)
- [Google Chrome](https://www.google.com/intl/en/chrome/browser/)

## How to develop

### Checkout and configure

- `$ git clone git@github.com:jmuheim/transition.git`
- `$ cd transition`
- `$ bundle install`
- `$ powder install`
- `$ powder link`

### Develop

- `$ powder open` opens [http://transition.dev/](http://transition.dev/) in the browser.
- `$ guard` starts Guard, which takes care about executing tests (using [Spring application preloader](https://github.com/jonleighton/spring)), live reloading of the page, etc.
- Use `binding.remote_pry` to set a breakpoint in code that is executed by the `POW` service and connect to it using `pry-remote` from the console.
- Use `binding.pry` to set a breakpoint in code that is run through an active console (e.g. `guard` or `rails s`)
- Execute `$ rip_hashrockets` from time to time to replace old Ruby hashrockets (`=>`) with the new syntax.

### Testing

- Use `@chrome` or `@selenium` flag to visually run acceptance tests in Chrome or Firefox.

## Backlog

You can find the backlog here: [`BACKLOG.md`](./blob/master/README.md).
