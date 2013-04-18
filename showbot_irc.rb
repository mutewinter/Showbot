require File.join(File.dirname(__FILE__), 'environment')

require 'optparse'
require 'cinchize'


# Required to parse the cinchize.yml file properly
YAML::ENGINE.yamler = 'syck'

Options = {
  :ontop => true,
  :system => false,
  :local_config => File.join(Dir.pwd, 'cinchize.yml'),
  :system_config => '/etc/cinchize.yml',
  :action => :start,
}

options = Options.dup

daemon = Cinchize::Cinchize.new *Cinchize.config(options, ARGV.first)
daemon.send options[:action]
