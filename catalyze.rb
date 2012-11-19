#!/usr/bin/ruby

require 'optparse'

def command?(name)
  `which #{name}`
  $?.success?
end

def run_command(command)
  success = system(command)
  if not success
    puts "Oops, it looks like there was an error..."
    exit
  end
end

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: catalyze.rb [options]"
  opts.on("-i", "--initialize", "Initailize server") do |i|
    options[:initialize] = i
  end
end.parse!

ip_address = ARGV.shift

if options[:initialize]
  if command?("ssh-copy-id")
    run_command "ssh-copy-id root@#{ip_address}"
  end
  puts "Initializing server for chef-solo..."
  run_command "ssh root@#{ip_address} 'bash -s' < setup.sh"
  puts "Finished initializing!"
end

puts "Copying chef scripts to the server..."
system("rsync -r . root@#{ip_address}:/var/chef")
puts "Setting up your server..."
system("ssh root@#{ip_address} \"chef-solo -c /var/chef/solo.rb\"")
puts "Finished!"
