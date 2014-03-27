# Base Project

[![Code Climate](https://codeclimate.com/github/jmuheim/base.png)](https://codeclimate.com/github/jmuheim/base)
[![Travis CI](https://api.travis-ci.org/jmuheim/base.png)](https://travis-ci.org/jmuheim/base)
[![Dependency Status](https://gemnasium.com/jmuheim/base.png)](https://gemnasium.com/jmuheim/base)
[![Coverage Status](https://coveralls.io/repos/jmuheim/base/badge.png)](https://coveralls.io/r/jmuheim/base)

## Uberspace

Public SSH Key installieren:

```
cat ~/.ssh/id_rsa.pub | ssh base@sirius.uberspace.de 'cat >> ~/.ssh/authorized_keys'
```

Zu Uberspace verbinden:

```
$ ssh base@sirius.uberspace.de
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

Passenger und Nginx installieren (wenn nach `chmod` gefragt wird, dann dieses **ohne** `sudo` ausführen!):

```
$ gem install passenger
$ passenger-install-nginx-module
```

Wenn nach dem Pfad fpr Nginx gefragt wird, `/home/<username>/nginx` angeben (`~/nginx` scheint nicht zu klappen)!

Danach `~/nginx/nginx.conf` anpassen. Zuoberst `daemon off;` einfügen (wir wollen Passenger via Daemontools kontrollieren), dann `server { ... }` folgendermassen anpassen/ergänzen:

```
server {
    listen            64253; # Hier einen freien Port wählen!
    server_name       base.sirius.uberspace.de;
    root              /home/base/rails/current/public;
    passenger_enabled on;

    # Den "location / { ... }" Block auskommentieren!
```

**Hinweis:** ausschließlich fünfstellige Ports zwischen 61000 und 65535 sind erlaubt! Bsp: wenn `netstat -tln | tail -n +3 | awk '{ print $4 }' | grep 64253` nichts zurück gibt, ist Port 64253 frei; hingegen `netstat -tulpen | grep :64253` zeigt an, welcher Prozess den Port 64253 blockiert.

Nun noch per Apache alle Requests auf `localhost:80` weiterleiten! `~/html/.htaccess` ergänzen:

```
RewriteEngine on
RewriteRule ^(.*)$ http://localhost:64253/$1 [P]
```

Daemontools installieren:

```
$ uberspace-setup-svscan
```

Nginx Service registrieren:

```
$ uberspace-setup-service nginx ~/nginx/sbin/nginx
```

Nginx Daemon starten:

```
$ svn -u ~/service/nginx
```

Mailer Email Account einrichten:

```
$ vsetup
$ vadduser mailer
l3tm3s3nd3m41lS!
l3tm3s3nd3m41lS!
```

App deployen (von lokaler Maschine aus):

```
$ mina setup
$ mina deploy
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
