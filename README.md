**Stack**

Linode - Ubuntu 12.04 LTS

This sets up 

- Nginx
- Unicorn
- Postgres
- rbenv to manage rubies
- Foreman for process management via Upstart

**Usage**

1. `setup.sh` installs base ruby, build dependencies and Chef.
2. `sync.sh` syncs the chef recipes to the server.
3. `update.sh` installs packages via chef.