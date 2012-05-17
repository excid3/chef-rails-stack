**Stack**

This sets up 

- NGinx
- PostGres
- User level RVM with ruby-1.9.3

**Usage**

1. `setup.sh` install base ruby, build dependencies and Chef.
2. `sync.sh` syncs the chef recipes to the server
3. `update.sh` installs packages via chef