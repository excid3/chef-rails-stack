**Stack**

Chef solo recipes for `Ubuntu 12.04 LTS 32 bit` that sets up

- Nginx
- Unicorn
- Postgres
- rbenv to manage rubies
- Foreman for process management via Upstart
- CopperEgg RevealCloud monitoring

**Usage**

1. `ssh root@yourserver.com 'bash -s' < setup.sh` installs base ruby, build dependencies and Chef.
2. Copy `node.json.example` and customize it
2. `sync.sh` syncs the chef recipes to the server.
3. `update.sh` installs packages via chef.
4. Run `sync.sh` and `update.sh` for installing additional packages