# Deployment

This documents explains how to deploy a Rails app to [Uberspace](http://www.uberspace.de) as a hosting provider and [InternetWorx](http://www.inwx.ch) as a domain registrar.

In the following document, replace `ACCOUNT` with your Uberspace account name (e.g. `base`), `SERVER` with the Uberspace server (e.g. `sirius`), `PROJECT` with your GitHub repository name (e.g. `base`), and `PORT` with an open port on the server! **When you worked through this document, remove this paragraph here, then commit the document.**

**Notice:** the `$` sign in code examples indicates a shell prompt! If you copy&pase, don't copy the `$` sign!

## Register new account

- Go to the [register](https://uberspace.de/register) page and create a new Uberspace account.
- Choose a password for your account (for webpanel access)
- Then add your public SSH key on the [authentication](https://uberspace.de/dashboard/authentication) page (**notice:** [Mina](http://nadarei.co/mina/) seems to have [problems with password authentication](http://stackoverflow.com/questions/22606771)!)
- You can see the chosen Uberspace server's name in the [datasheet](https://uberspace.de/dashboard/datasheet)
- Now you can connect to your account: `$ ssh ACCOUNT@SERVER.uberspace.de`

**Notice:** In the following document, execute commands of sections with a superscripted "local" on your local shell, and commands of sections with a superscripted "remote" on your server's shell.

## Forward system mail to your account <sup>(remote)</sup>

In the following code snippet, replace `email@example.com` with your own email address. Remember: it makes sense here to use an email address that's completely independent from Uberspace or any domain that you're intending to use with Uberspace.

- `$ echo email@example.com > ~/.qmail`
- `$ echo ./Maildir/ >> ~/.qmail` (optional, to keep a copy of the mail)

## Update default URL options <sup>(local)</sup>

Change the default URL options' `:host` in `config/environments/production.rb` to `http://ACCOUNT.SERVER.uberspace.de`.

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
server {
    listen            PORT; # Choose an open port (see instructions below)!
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

# Redirect browser from non-www to www address
RewriteCond %{HTTP_HOST} !^www\.
RewriteRule ^(.*)$ http://www.%{HTTP_HOST}/$1 [R=301,L]

# Redirect everything to Passenger
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

## Add GitHub to known hosts <sup>(remote)</sup>

- Add your SSH public key to GitHub: https://help.github.com/articles/adding-a-new-ssh-key-to-your-github-account/
- Execute `ssh -T git@github.com` and confirm.

## Setup Mina <sup>(local)</sup>

- Edit [`config/deploy.rb`](config/deploy.rb) and set the correct `:server_name`, `:user`, and `:repository_name`. Commit everything into `master` branch (or also set the `:branch` option to your branch name).

Be sure you have commited and pushed all changes.

Execute `$ mina setup`. Use the `--verbose` and `--trace` switch for debugging if something goes wrong.

## Secrets.yml

Create `/home/ACCOUNT/rails/shared/config/secrets.yml` and add a secret key for `production` (use `$ rails secret` to create a new key):

```
production:
  secret_key_base: <insert-key-here>
  database:
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

You may now want to update the link to the live project in `README.md`. :-)

## Add domain(s) <sup>(remote)</sup>

For website use:

- `$ uberspace-add-domain -d example.com -w` adds domain `example.com`
- `$ uberspace-add-domain -d www.example.com -w` adds subdomain `www.example.com`

For mail use:

- `$ uberspace-add-domain -d example.com -m -e example` adds domain `example.com` with namespace `example`

### DNS

Add the following records to the DNS for the domain:

- IPv4: `dig <server>.uberspace.de A +short`
- IPv6: `dig <server>.uberspace.de AAAA +short`
- Aliases (CNAME):
  - `www`
  - `autoconfig` and `autodiscover` (for [automx](https://wiki.uberspace.de/mail:automx) support)
- Email (MX):
  - `SERVER.uberspace.de` with priority `5`

## Create email account(s)<sup>(remote)</sup>

Create account `user` in namespace `example`:

- `$ vadduser example-user`

Mail sent to `user@example.com` will be received by this account.

## Configure mail client <sup>local</sup>

OSX Mail:

- Go to [http://automx.SERVER.uberspace.de](http://automx.SERVER.uberspace.de) and create and download a `.mobileconfig` file
- Execute the file

Thunderbird:

- Just add the account in the account settings using user name and password - Thunberbird will automatically detect the correct settings!

## Additional information

- If you ever have to inspect server logs, they're here: `/home/ACCOUNT/nginx/logs/error.log`