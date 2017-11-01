# Backup

## Backup everything using backup gem <sup>(remote)</sup>

- `$ gem install backup`
- `$ backup generate:model --trigger=ACCOUNT`

Replace the content of `~/Backup/models/ACCOUNT.rb` with the following (don't forget to replace placeholders like `your@email.here`):

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
    mail.password             = "???"
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

## Backup database manually <sup>remote</sup>

- `$ mysqldump -u ACCOUNT -p ACCOUNT > db_backup.sql`

## Restore database manually <sup>remote</sup>

