#!/usr/bin/env bash
apt-get -y update
apt-get -y install build-essential zlib1g-dev libssl-dev libreadline-gplv2-dev libyaml-dev ruby1.9.3
wget -O ~/.gemrc https://raw.github.com/gist/2709206/97bb8bc0a2f12764cd82478c7118f209b2aa84d8/gemrc
gem install rake chef
mkdir -p /var/chef/cookbooks /var/chef/cache
