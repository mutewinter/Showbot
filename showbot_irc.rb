require File.join(File.dirname(__FILE__), 'environment')

require 'cinchize'


# Required to parse the cinchize.yml file properly
YAML::ENGINE.yamler = 'syck'

Cinchize.run
