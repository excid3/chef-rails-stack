DESCRIPTION
====

Installs nginx from package OR source code and sets up configuration handling similar to Debian's Apache2 scripts.

REQUIREMENTS
====

Cookbooks
----

* build-essential (for nginx::source)
* runit (for nginx::source)

Platform
----

Debian or Ubuntu though may work where 'build-essential' works, but other platforms are untested.

ATTRIBUTES
====

All node attributes are set under the `nginx` namespace.

* version - sets the version to install.
* dir - configuration dir.
* `log_dir` - where logs go.
* user - user to run as.
* binary - path to nginx binary.
* gzip - all attributes under the `gzip` namespace configure the gzip module.
* keepalive - whether to use keepalive.
* `keepalive_timeout` - set the keepalive timeout.
* `worker_processes` - number of workers to spawn.
* `worker_connections` - number of connections per worker.
* `server_names_hash_bucket_size`
* `server_tokens` - sets the value for the server_tokens directive (on|off)

The following attributes are set at the 'normal' node level via the `nginx::source` recipe.

* `install_path` - for nginx::source, sets the --prefix installation.
* `src_binary` - for nginx::source, sets the binary location.
* `configure_flags` - for nginx::source, an array of flags to use for compilation.
* `daemon_disable` - for nginx::source, runs NGINX in a non-daemon mode for runit.
* `modules` - for nginx::source, an array of `module_recipes` to be compiled into NGINX.

Module Recipes
---

A recipe which appends additional flags to the `configure_flags` attribute prior to compilation in the nginx::source recipe. In addition, any module specific configurations are performed in each module recipe.

List of included module recipes:
* `http_geoip_module` - compiles geoip support into NGINX, configures NGINX, and downloads the Geoip databases
* `http_gzip_static_module` - compiles the `gzip_static_module` into NGINX
* `http_realip_module` - compiles and configures `realip_module` into NGINX
* `http_ssl_module` - compiles `http_ssl_module` into NGINX
* `http_stub_status_module` - compiles and configures `http_stub_status_module` into NGINX
* `upload_progress_module` - downloads, compiles, and configures `upload_progress_module` into NGINX

Review each module recipe additional configurable attributes.

USAGE
====

Provides two ways to install and configure nginx.

* Install via native package (nginx::default)
* Install via compiled source (nginx::source)

Both recipes implement configuration handling similar to the Debian Apache2 site enable/disable.

There's some redundancy in that the config handling hasn't been separated from the installation method (yet), so use only one of the recipes.

Some of the attributes mentioned above are only set in the `nginx::source` recipe. They can be overridden by setting them via a role in `override_attributes`.

LICENSE and AUTHOR
====

Author:: Joshua Timberman (<joshua@opscode.com>)
Author:: Adam Jacob (<adam@opscode.com>)
Author:: AJ Christensen (<aj@opscode.com>)
Author:: Jamie Winsor (<jamie@vialstudios.com>)

Copyright:: 2008-2011, Opscode, Inc

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
