# Deployment

We chose [Uberspace](http://www.uberspace.de) as our hosting provider and [InternetWorx](http://www.inwx.ch) as our domain registrar.

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
daemon off; # We execute Nginx using Daemontools # <-- Do we still need this??

...

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

Execute `ssh -T git@github.com` and confirm.

## Setup Mina <sup>(local)</sup>

- Edit [`config/deploy.rb`](config/deploy.rb) and set the correct `:server_name`, `:user`, and `:repository_name`. Commit everything into `master` branch (or also set the `:branch` option to your branch name).

Be sure you have commited and pushed all changes.

Execute `$ mina setup`. Use the `--verbose` and `--trace` switch for debugging if something goes wrong.

## Database <sup>(remote)</sup>

Then edit `~/rails/shared/config/database.yml` and add the following:

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

## Backup using backup gem <sup>(remote)</sup>

- `$ gem install backup`
- `$ backup generate:model --trigger=ACCOUNT`

Replace the content of `~/Backup/models/ACCOUNT.rb` with the following (don't forget to replace `your@email.here` with your email address):

```
# encoding: utf-8

##
# Backup Generated: ACCOUNT
# Once configured, you can run the backup with the following command:
#
# $ backup perform -t ACCOUNT [-c <path_to_configuration_file>]
#
# For more information about Backup's components, see the documentation at:
# http://backup.github.io/backup
#
Model.new(:ACCOUNT, 'Full backup of ACCOUNT (database and uploaded files), copied to FTP') do

  ##
  # MySQL [Database]
  #
  database MySQL do |db|
    # To dump all databases, set `db.name = :all` (or leave blank)
    db.name               = "ACCOUNT"
    db.username           = "ACCOUNT"
    db.password           = "lacoidTejeewricajDeb"
    db.host               = "localhost"
    db.port               = 3306
    db.socket             = "/var/lib/mysql/mysql.sock"
    # Note: when using `skip_tables` with the `db.name = :all` option,
    # table names should be prefixed with a database name.
    # e.g. ["db_name.table_to_skip", ...]
    # db.skip_tables        = ["skip", "these", "tables"]
    # db.only_tables        = ["only", "these", "tables"]
    # db.additional_options = ["--quick", "--single-transaction"]
  end

  archive :uploads do |archive|
    # Run the `tar` command using `sudo`
    # archive.use_sudo
    archive.add '~/rails/shared/public/uploads/'
    archive.exclude '~/rails/shared/public/uploads/tmp/'
  end

  # store_with Dropbox do |db|
  #   db.api_key     = "ijvrikaqtyhv48e"
  #   db.api_secret  = "w2xingwdobq9uxk"
  #   # Sets the path where the cached authorized session will be stored.
  #   # Relative paths will be relative to ~/Backup, unless the --root-path
  #   # is set on the command line or within your configuration file.
  #   db.cache_path  = ".cache"
  #   # :app_folder (default) or :dropbox
  #   db.access_type = :app_folder
  #   db.path        = ""
  #   db.keep        = 25
  # end

  store_with FTP do |server|
    server.username     = 'ACCOUNT-backup'
    server.password     = '5OUwqL5496EuHWCGWDKy'
    server.ip           = '80.74.144.35'
    server.port         = 21
    server.path         = '~/'
    server.keep         = 10
    server.passive_mode = true
  end

  store_with Local do |local|
    local.path = '~/Backup/backups/'
    local.keep = 5
  end

  ##
  # Gzip [Compressor]
  #
  compress_with Gzip

  ##
  # Mail [Notifier]
  #
  # The default delivery method for Mail Notifiers is 'SMTP'.
  # See the documentation for other delivery options.
  #
  notify_by Mail do |mail|
    mail.on_success           = false
    mail.on_warning           = true
    mail.on_failure           = true

    mail.from                 = "ACCOUNT@SERVER.uberspace.de"
    mail.to                   = "your@email.here"
    mail.address              = "SERVER.uberspace.de"
    mail.port                 = 587
    mail.domain               = "SERVER.uberspace.de"
    mail.user_name            = "ACCOUNT-mailer"
    mail.password             = "m41ls4r3funnY!"
    mail.authentication       = "login"
    mail.encryption           = :starttls
  end
end
```

### Automate daily backup

- `$ gem install whenever`
- `$ cd ~/Backup`
- `$ mkdir config`
- `$ wheneverize .`

Add the following to `config/schedule.rb`:

```
every 1.day, :at => '11:30 pm' do
  command "backup perform -t ACCOUNT"
end
```

Now update crontab:

- `$ whenever --update-crontab`