# Deployment

We chose [Uberspace](http://www.uberspace.de) as our hosting provider.

In the following document, always replace `ACCOUNT` with your Uberspace account name (e.g. `base`), `SERVER` with the Uberspace server (e.g. `sirius`), `PROJECT` with your GitHub repository name (e.g. `base`), and `PORT` with an open port on the server!

## Register new account

- Go to the [register](https://uberspace.de/register) page and create a new Uberspace account.
- Choose a password for your account (for webpanel access)
- Then add your public SSH key on the [authentication](https://uberspace.de/dashboard/authentication) page (**notice:** [Mina](http://nadarei.co/mina/) seems to have [problems with password authentication](http://stackoverflow.com/questions/22606771)!)
- You can see the chosen Uberspace's name in the [datasheet](https://uberspace.de/dashboard/datasheet)
- Now you can connect to your account: `$ ssh ACCOUNT@SERVER.uberspace.de`

## Update default URL options <sup>(local)</sup>

Change the default URL options' `:host` in `config/environments/production.rb` to `http://ACCOUNT.SERVER.uberspace.de`.

## Setup Mina <sup>(local)</sup>

- Edit [`config/deploy.rb`](config/deploy.rb) and set the correct `:server_name`, `:user`, and `:repository_name`. Commit everything int `master` branch (or also set the `:branch` option to your branch name).

## Setup Ruby <sup>(remote)</sup>

**Notice:** the `$` sign in code examples indicates a shell prompt! If you copy&pase, don't copy the `$` sign!

To [activate Ruby 2.1](http://uberspace.de/dokuwiki/cool:rails#ruby_aktivieren), execute the following:

```
$ cat <<'__EOF__' >> ~/.bash_profile
export PATH=/package/host/localhost/ruby-2.1.1/bin:$PATH
export PATH=$HOME/.gem/ruby/2.1.0/bin:$PATH
__EOF__
```

Load your new configuration:

```
$ . ~/.bash_profile
```

`ruby -v` should now output something like this:

```
$ ruby -v
ruby 2.1.1p76 (2014-02-24 revision 45161) [x86_64-linux]
```

## Setup gems management <sup>(remote)</sup>

[Rails, bundler and other gems](https://uberspace.de/dokuwiki/cool:rails) need to be installed always in our user's directory.

- `$ echo "gem: --user-install --no-rdoc --no-ri" > ~/.gemrc`
- `$ gem install bundler`
- `$ bundle config path ~/.gem`

## Setup Passenger with Nginx <sup>(remote)</sup>

- `$ gem install passenger`
- `$ passenger-install-nginx-module`
    - select `Ruby` when prompted
    - if you're told to cancel and execute a `$ chmod ...`, then simply press `Enter` to continue
    - select `Yes: download, compile and install Nginx for me.` when prompted
    - when told to enter path, enter `/home/ACCOUNT/nginx`

### Configuration

Edit `~/nginx/conf/nginx.conf` like so:

```
daemon off; # We execute Nginx using Daemontools

...

server {
    listen            PORT; # Choose an open port (see instuctions below)!
    server_name       ACCOUNT.SERVER.uberspace.de;
    root              /home/ACCOUNT/rails/current/public;
    passenger_enabled on;

    # Be sure to remove or comment the `location / { ... }` block!
}
```

- To check whether a port is open, execute `netstat -tulpen | grep :PORT`: empty output means the port is open, otherwise the blocking process is displayed.
- **Notice:** only [ports](http://uberspace.de/dokuwiki/system:ports) within 61000 and 65535 are allowed!

### Forward web requests to Passenger

Add to `~/html/.htaccess`:

```
RewriteEngine on
RewriteRule ^(.*)$ http://localhost:PORT/$1 [P]
```

## Daemontools <sup>(remote)</sup>

- `$ uberspace-setup-svscan` activates [daemontools](http://uberspace.de/dokuwiki/system:daemontools)
- `$ uberspace-setup-service nginx ~/nginx/sbin/nginx` registers nginx as daemon

The daemon is started automatically. You can execute `$ svc -u ~/service/nginx` to manually start it (use `-d` to stop and `-h` to reload it).

## Mailer email account <sup>(remote)</sup>

To send Mails using SMTP, we need a mailer email account.

- `$ vsetup` activates [email account management](http://uberspace.de/dokuwiki/start:mail)
- `$ vadduser mailer`
- `l3tm3s3nd3m41lS!` (2 times)

To config `ActionMailer`, edit [`config/application.rb`](config/application.rb):

```
ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
  address:              'SERVER.uberspace.de',
  port:                 587,
  domain:               'SERVER.uberspace.de',
  user_name:            'ACCOUNT-mailer',
  password:             'l3tm3s3nd3m41lS!',
  authentication:       'login',
  enable_starttls_auto: true
}
```

## Setup Mina <sup>(local)</sup>

Execute `$ mina setup`. Use the `--verbose` and `--trace` switch for debugging if something goes wrong.

## Database <sup>(remote)</sup>

Then, on the server, edit `~/rails/shared/config/database.yml` and add the following:

```
production:
  adapter: mysql2
  encoding: utf8
  username: ACCOUNT
  password: ???
  database: ACCOUNT
  socket: /var/lib/mysql/mysql.sock
```

The password for [MySQL](http://uberspace.de/dokuwiki/database:mysql) can be found in the file `~/.my.cnf`.

## First run <sup>(local)</sup>

It's time for the first deployment: execute `$ mina deploy`! Use the `--verbose` and `--trace` switch for debugging if something goes wrong.

Now go to [http://ACCOUNT.SERVER.uberspace.de](http://ACCOUNT.SERVER.uberspace.de) and enjoy your site!
