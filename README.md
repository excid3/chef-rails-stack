# Catalyzer

Chef solo recipes for `Ubuntu 12.04 LTS` that sets up:

- Nginx
- Passenger
- Postgres
- rbenv to manage rubies

## Usage

The following steps will connect to your server as the root user in
order to install and configure your environment. Replace `IP_ADDRESS`
with your server's IP address in the following commands.

1. If you haven't already, use `ssh-copy-id root@IP_ADDRESS` to enable
   passwordless SSH for your server. That will remove the need for you
to type in your password multiple times during the process.

2. Open up `node.json` and change the user password for the deploy user
   AND for postgres.

### First Time
The first step is to initialize your server for using Chef. I've
packaged all the necessary dependencies into Catalyzer for you. All
you need to do is use the `--initialize` option the first time.

    ruby catalyze.rb IP_ADDRESS --initialize

### Normal Usage

The last step is to actually run Chef on your server. This will run
through all of the packages we want to install and install them.

    ruby catalyze.rb IP_ADDRESS

And that's it!
