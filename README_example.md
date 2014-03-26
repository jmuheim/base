# Base Project

[![Code Climate](https://codeclimate.com/github/jmuheim/base.png)](https://codeclimate.com/github/jmuheim/base)
[![Travis CI](https://api.travis-ci.org/jmuheim/base.png)](https://travis-ci.org/jmuheim/base)
[![Dependency Status](https://gemnasium.com/jmuheim/base.png)](https://gemnasium.com/jmuheim/base)
[![Coverage Status](https://coveralls.io/repos/jmuheim/base/badge.png)](https://coveralls.io/r/jmuheim/base)

## Uberspace

Zu Uberspace verbinden:

```
$ ssh base@sirius.uberspace.de
```

Public SSH Key installieren:

```
cat "MY-PUBLIC-SSH-KEY" >> ~/.ssh/authorized_keys
```

Ruby 2.1 aktivieren:

```
$ cat <<'__EOF__' >> ~/.bash_profile
export PATH=/package/host/localhost/ruby-2.1.1/bin:$PATH
export PATH=$HOME/.gem/ruby/2.1.0/bin:$PATH
__EOF__
$ . ~/.bash_profile
```

Gems immer lokal installieren:

```
echo "gem: --user-install --no-rdoc --no-ri" > ~/.gemrc
```

Bundler installieren:

```
$ gem install bundler
```

Bundler veranlassen, Gems ebenfalls lokal zu installieren:

```
$ bundle config path ~/.gem
```

FCGI Weiterleitung einrichten:

```
$ cat <<__EOF__ > ~/fcgi-bin/rails
#!/bin/sh

# This is needed to find gems installed with --user-install
export HOME=$HOME

# Include our profile to get Ruby 1.9.2 included in our PATH
. \$HOME/.bash_profile

# This makes Rails/Rack think we're running under FastCGI. WTF?!
# See ~/.gem/ruby/1.9.1/gems/rack-1.2.1/lib/rack/handler.rb
export PHP_FCGI_CHILDREN=1

# Get into the project directory and start the Rails server
cd \$HOME/rails/current
exec bundle exec rails server
__EOF__
```

Dann noch ausführbar machen:

```
$ chmod 755 ~/fcgi-bin/rails
```

HTACCESS Regel erstellen für Weiterleitung:

```
$ cat <<__EOF__ >> ~/html/.htaccess
RewriteEngine on
RewriteRule ^(.*)$ /fcgi-bin/rails/\$1 [QSA,L]
__EOF__
```

Email Account einrichten:

```
$ vsetup
$ vadduser mailer
l3tm3s3nd3m41lS!
l3tm3s3nd3m41lS!
```

## Developer Environment

- [Mac OS X](http://www.apple.com/osx/)
- [Git](http://git-scm.com/)
- [Google Chrome](https://www.google.com/intl/en/chrome/browser/)

## How to develop

### Checkout and configure

- `$ git clone git@github.com:jmuheim/base.git`
- `$ cd base`
- `$ bundle install`
- Change the value of `Port:` in `config/boot.rb` to e.g. `3002`
- Change the value of `port:` in `Guardfile` and the value of `live_reload_port:` in `config/environments/development.rb` to e.g. `357230`.

You can use [direnv](https://github.com/zimbatm/direnv) to automatically add `bin` to your `$PATH`. Otherwise you should always use `bundle exec` to run commands.

### Developing

- In one terminal, enter `$ server` to start the development server using [rerun](https://github.com/alexch/rerun) (which will take care of restarting the server upon changes of important config files)
- In a second terminal, enter `$ guard` to start Guard, which automatically takes care of:
  - executing tests using [Guard-RSpec](https://github.com/guard/guard-rspec)
  - live reloading the page (HTML, JS and CSS) using [Guard-LiveReload](https://github.com/guard/guard-livereload)
  - bundling using [Guard-Bundler](https://github.com/guard/guard-bundler)
  - annotating models using [Guard-Annotate](https://github.com/cpjolicoeur/guard-annotate)
  - migrating the DB using [Guard-Migrate](https://github.com/glanotte/guard-migrate)
- Execute `$ rip_hashrockets` from time to time to replace old Ruby hashrockets (`=>`) with the new syntax

### Testing

- Use `@chrome` or `@selenium` flag to visually run acceptance tests in Chrome or Firefox.

## Deploying

- **Before deploying**, run `rake HEADHUNTER=true` to make sure all HTML and CSS is in good shape.

### Travis CI

- Project is configured to be continuously integrated using [Travis CI](https://travis-ci.org/jmuheim/base).

## Backlog

You can find the backlog here: [`BACKLOG.md`](./BACKLOG.md).
