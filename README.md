**Stack**

Chef solo recipes for `Linode - Ubuntu 12.04 LTS` that sets up

- Nginx
- Unicorn
- Postgres
- rbenv to manage rubies
- Foreman for process management via Upstart

**Usage**

1. `ssh root@yourserver.com 'bash -s' < setup.sh` installs base ruby, build dependencies and Chef.
2. `sync.sh` syncs the chef recipes to the server.
3. `update.sh` installs packages via chef.