# Deployment

This documents explains how to deploy a Rails app to [Uberspace](http://www.uberspace.de) as a hosting provider and [InternetWorx](http://www.inwx.ch) as a domain registrar.

In the following document, replace `ACCOUNT` with your Uberspace account name (e.g. `base`), `SERVER` with the Uberspace server (e.g. `sirius`), `PROJECT` with your GitHub repository name (e.g. `base`), and `PORT` with the Rails app's port (I suggest using one close to but above `3001`)! **When you worked through this document, remove this paragraph here, then commit the document.**

**Notice:** the `$` sign in code examples indicates a shell prompt! If you copy&pase, don't copy the `$` sign!

## Register new account

- Go to the [register](https://uberspace.de/register) page and create a new Uberspace account.
- Then add your public SSH key on the [Logins](https://uberspace.de/dashboard/authentication) page.
    - To view your public SSH key, do `$ cat ~/.ssh/id_rsa.pub`.
- You can see the chosen Uberspace server's name in the [Datasheet](https://uberspace.de/dashboard/datasheet).
- Now you can connect to your account: `$ ssh ACCOUNT@SERVER.uberspace.de`.
    - Confirm the question `Are you sure you want to continue connecting?` with a heartly `yes`.

## Add GitHub to known hosts

- Add your SSH public key to GitHub: https://help.github.com/articles/adding-a-new-ssh-key-to-your-github-account/
    - Like above, to view your public SSH key, do `$ cat ~/.ssh/id_rsa.pub`.
- On your local console, execute `ssh -T git@github.com` and confirm.
    - You should see something like `Hi user! You've successfully authenticated, but GitHub does not provide shell access.`.

## Mailer email account

To send Mails using SMTP, we need a mailer email account.

- On Uberspace, execute `$ uberspace mail user add mailer`.
- Remember the password for later use!

## Secrets.yml

Create `/home/ACCOUNT/rails/shared/config/secrets.yml` and set up a `deployment` config according to `config/secrets.example.yml` (remove `development` and `test` configs).

The database info can be found in the file `~/.my.cnf`.

## Setting up Capistrano

- Edit `config/deploy.rb` and set:
    - `:application` to something like `'Base'`.
    - `:repo_url` to something like `'git@github.com:jmuheim/base.git'`.
    - `:deploy_to` to something like `'/home/ACCOUNT/rails'`.
    - `:puma_bind` to something like `'tcp://0.0.0.0:PORT'` (use the same port as `app_port` in `secrets.yml`, e.g. `3001`).
- Edit `config/deploy/production.rb` and add a line like `server "ACCOUNT.uberspace.de", user: "ACCOUNT", roles: %w{web app db}`
- Save the files, commit and push the branch.

## First deployment

The first deployment is a special one, as it needs to load the database schema (it is called a "cold" deploy). Any subsequent deployments won't do this; instead they will trigger the database migrations.

On your local console, execute `$ cap production deploy_cold`. This could take some minutes (installing and compiling gems).

## Configure web backend

The Rails app is now running in the background and accepts request on the specified port. To make this port accessible to the outside world, we need to route incoming requests to it.

- On Uberspace, execute `$ uberspace web backend set / --http --port PORT` (use the same port as `app_port` in `secrets.yml`, e.g. `3001`).
    - To verify that the server actually is running on the specified port, execute `$ ps aux | grep puma`.
- Now go to [http://ACCOUNT.uber.space](http://ACCOUNT.uber.space) and enjoy your site!

You may now want to update the link to the live project in `README.md`. :-)

## Populate database

### Option 1: Seed data

To populate the database with initial records (seeds), execute `$ cap production db_seed`. See `db/seeds.rb` for more details about the seed data.

### Option 2: Import data

To use existing data (maybe from another running instance, or from your development instance), feel free to simply export the database tables in question and import them into the database.

## Further deployments

For any further deployment, simply push all your changes, then run `$ cap production deploy`.

## Additional info about Uberspace

Setup of deployment ends here. The following is a collection of additional useful information regarding Uberspace.

### Add domain

For website use, on Uberspace, execute:

- `$ uberspace web domain add example.com` to add domain `example.com`
- `$ uberspace web domain add www.example.com` to add subdomain `www.example.com`

For mail use, on Uberspace, execute:

- `$ uberspace mail domain add example.com` adds domain `example.com`

#### DNS

Add the following records to the DNS for the domain (at your domain registrar's control panel, in our case [InternetWorx](http://www.inwx.ch)):

- IPv4: `dig <server>.uberspace.de A +short`
- IPv6: `dig <server>.uberspace.de AAAA +short`
- Aliases (CNAME):
  - `www`
  - `autoconfig` and `autodiscover` (for [automx](https://wiki.uberspace.de/mail:automx) support)
- Email (MX):
  - `SERVER.uberspace.de` with priority `5`

### Create email account(s)<sup>(remote)</sup>

Create account `user` in namespace `example`:

- `$ vadduser example-user`

Mail sent to `user@example.com` will be received by this account.

### Configure mail client <sup>local</sup>

OSX Mail:

- Go to [http://automx.SERVER.uberspace.de](http://automx.SERVER.uberspace.de) and create and download a `.mobileconfig` file
- Execute the file

Thunderbird:

- Just add the account in the account settings using user name and password - Thunberbird will automatically detect the correct settings!
