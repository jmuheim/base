# Deployment

We chose [Uberspace](http://www.uberspace.de) as our hosting provider.

In the following document, always replace `ACCOUNT` with your account name (e.g. `base`) and `SERVER` with the used Uberspace server (e.g. `sirius`)!

## Register new account

- Go to the [register](https://uberspace.de/register) page and create a new Uberspace account.
- Then add your public SSH key on the [authentication](https://uberspace.de/dashboard/authentication) page (**notice:** [Mina](http://nadarei.co/mina/) seems to have [problems with password authentication](http://stackoverflow.com/questions/22606771)!)
- Now you can connect to your account: `$ ssh ACCOUNT@SERVER.uberspace.de`

## Setup Ruby

To activate Ruby 2.1, execute the following:

```
$ cat <<'__EOF__' >> ~/.bash_profile
export PATH=/package/host/localhost/ruby-2.1.1/bin:$PATH
export PATH=$HOME/.gem/ruby/2.1.0/bin:$PATH
__EOF__
$ . ~/.bash_profile
```

## Setup Bundler

- `$ echo "gem: --user-install --no-rdoc --no-ri" > ~/.gemrc`
- `$ gem install bundler`
- `$ bundle config path ~/.gem`

## Setup Passenger with Nginx

- `$ gem install passenger` (if you're told to execute a `$ chmod ...`, then run it **without** `sudo`!)
- `$ passenger-install-nginx-module` (when told to enter path, enter `/home/ACCOUNT/nginx`)

### Configuration

Edit `~/nginx/nginx.conf` like so: ` einfügen (wir wollen Passenger via Daemontools kontrollieren), dann `server { ... }` folgendermassen anpassen/ergänzen:

```
daemon off; # We execute Nginx using Daemontools

...

server {
    listen            64253; # Choose an open port (see instuctions below)!
    server_name       ACCOUNT.SERVER.uberspace.de;
    root              /home/ACCOUNT/rails/current/public;
    passenger_enabled on;

    # Be sure to remove or comment the `location / { ... }` block!
}
```

- To check whether a port is open, execute `netstat -tln | tail -n +3 | awk '{ print $4 }' | grep 64253`: empty output means the port is open.
- To find out which process is blocking a port, execute `netstat -tulpen | grep :64253`.
- **Notice:** only ports within 61000 and 65535 are allowed!

### Forward web requests to Passenger

Add to `~/html/.htaccess`:

```
RewriteEngine on
RewriteRule ^(.*)$ http://localhost:64253/$1 [P]
```

## Daemontools

- `$ uberspace-setup-svscan` activates daemontools
- `$ uberspace-setup-service nginx ~/nginx/sbin/nginx` registers nginx as daemon
- `$ svc -u ~/service/nginx` starts the service (use `-d` to stop it and `-h` to reload it)

## Mailer Email Account

To send Mails using SMTP, we need a mailer email account.

- `$ vsetup` activates email account management
- `$ vadduser mailer`
- `l3tm3s3nd3m41lS!`
- `l3tm3s3nd3m41lS!`

To see how to config `ActionMailer`, go to [`./config/application.rb`](config/application.rb).

## Database

**Locally**, execute `$ mina setup`. Use the `--verbose` and `--trace` switch for debugging if something goes wrong.

Then, on the server, edit `~/rails/shared/config/database.yml` and add the following:

```
production:
  adapter: mysql2
  encoding: utf8
  username: base
  password: (find me in ~/.my.cnf)
  database: ACCOUNT
  socket: /var/lib/mysql/mysql.sock
```
