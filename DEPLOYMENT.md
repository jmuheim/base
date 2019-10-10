# Deployment

This documents explains how to deploy a Rails app to [Uberspace](http://www.uberspace.de) as a hosting provider and [InternetWorx](http://www.inwx.ch) as a domain registrar.

In the following document, replace `ACCOUNT` with your Uberspace account name (e.g. `base`), `SERVER` with the Uberspace server (e.g. `sirius`), `PROJECT` with your GitHub repository name (e.g. `base`), and `PORT` with the Rails app's port (I suggest using one close to but above `3001`)! **When you worked through this document, remove this paragraph here, then commit the document.**

**Notice:** the `$` sign in code examples indicates a shell prompt! If you copy&pase, don't copy the `$` sign!

## Register new account

- Go to the [register](https://uberspace.de/register) page and create a new Uberspace account.
- Then add your public SSH key on the [Logins](https://uberspace.de/dashboard/authentication) page (**notice:** [Mina](http://nadarei.co/mina/) seems to have [problems with password authentication](http://stackoverflow.com/questions/22606771)!).
    - To view your public SSH key, do `$ cat ~/.ssh/id_rsa.pub`.
- You can see the chosen Uberspace server's name in the [Datasheet](https://uberspace.de/dashboard/datasheet).
- Now you can connect to your account: `$ ssh ACCOUNT@SERVER.uberspace.de`.
    - Confirm the question `Are you sure you want to continue connecting?` with a heartly `yes`.

## Nginx as service

Nginx will receive web requests from the outside and pass them to the Rails app. A service (or daemon) is a program that starts automatically and is kept in the background. In case it quits or crashes, it is restarted by `supervisord`.

To setup Nginx as a service, on Uberspace, create `~/etc/services.d/nginx.ini` with following content:

```
[program:nginx]
command=/home/audit/nginx/sbin/nginx
autostart=yes
autorestart=yes
```

Then, on Uberspace:

- Ask supervisord to look for new .ini files: `$ supervisorctl reread`.
- Start your daemon: `$ supervisorctl update`.

## Mailer email account

To send Mails using SMTP, we need a mailer email account.

- On Uberspace, execute `$ uberspace mail user add mailer`.
- (Remember the password for later use!)

## Add GitHub to known hosts

- Add your SSH public key to GitHub: https://help.github.com/articles/adding-a-new-ssh-key-to-your-github-account/
- On your local console, execute `ssh -T git@github.com` and confirm.
    - You should see something like `Hi user! You've successfully authenticated, but GitHub does not provide shell access.`.

## Setup Mina

- Edit [`config/deploy.rb`](config/deploy.rb) and set `:app_name`, `:domain`, `:deploy_to`, `:repository`, `:user`, and `:puma_port`.
- Save the file, commit and push.
- On your local console, execute `$ mina setup`.
    - This will deploy the current branch; to deploy another branch, use `$ branch=my-branch mina setup`.
    - If something goes wrong, use the `--verbose` and `--trace` switch for debugging.

## Mailer email account

To send Mails using SMTP, we need a mailer email account.

- On Uberspace, execute `$ uberspace mail user add mailer`.
- (Remember the password for later use!)

## Secrets.yml

Create `/home/ACCOUNT/rails/shared/config/secrets.yml` and set up a `deployment` config according to `config/secrets.example.yml` (just remove `development` and `test` configs).

The database info can be found in the file `~/.my.cnf`.

## First deployment

It's time for the first deployment:

- Be sure you have pushed the current branch to GitHub.
- Comment out the following two lines in `config/deploy.rb` by adding a `#` in front, and save the file:
    - `invoke :'rails:db_schema_load'` becomes `# invoke :'rails:db_schema_load'`.
    - `command %{#{fetch(:rails)} db:seed}` becomes `# command %{#{fetch(:rails)} db:seed}`.
- On your local console, execute `$ mina deploy`.
    - This could take some minutes (installing and compiling gems).
    - If something goes wrong, use the `--verbose` and `--trace` switch for debugging (e.g. `$ mina deploy --verbose`).
- After successful first deployment, comment out the two lines above again (revert to original state), and save the file.

## Configure web backend

The Rails app is now running in the background and accepts request on the specified port. To make this port accessible to the outside world, we need to route incoming requests to it.

- On Uberspace, execute `$ uberspace web backend set / --http --port PORT` (replace `PORT` with the value of `app_port` in `secrets.yml`, e.g. `3001`).
- Now go to [http://ACCOUNT.uber.space](http://ACCOUNT.uber.space) and enjoy your site!

You may now want to update the link to the live project in `README.md`. :-)

## Add domain

For website use, on Uberspace, execute:

- `$ uberspace web domain add example.com` to add domain `example.com`
- `$ uberspace web domain add www.example.com` to add subdomain `www.example.com`

For mail use, on Uberspace, execute:

- `$ uberspace mail domain add example.com` adds domain `example.com`

### DNS

Add the following records to the DNS for the domain (at your domain registrar's control panel, in our case [InternetWorx](http://www.inwx.ch)):

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
