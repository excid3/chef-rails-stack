##Stack

Chef solo recipes for `Ubuntu 12.04 LTS` that sets up:

- Nginx
- Unicorn
- Postgres
- rbenv to manage rubies
- Foreman for process management via Upstart

##Usage

The following steps will connect to your server as the root user in
order to install and configure your environment.

1. `./initialize.sh IP_ADDRESS` to install Ruby, the dependencies and Chef
2. `cp node.json.example node.json` and change the passwords to what
   you choose.
3. `./sync.sh IP_ADDRESS` syncs the chef recipes to the server.
4. `./update.sh IP_ADDRESS` installs packages via chef.
5. Repeat steps 3 and 4 if you make changes to your configuration.
