require 'rubygems'
require 'bundler/setup'
require 'rspec/core/rake_task'
require 'daemons'

task :default => :test
task :test => :spec

if !defined?(RSpec)
  puts "spec targets require RSpec"
else
  desc "Run all examples"
  RSpec::Core::RakeTask.new(:spec) do |t|
    t.pattern = 'spec/**/*.rb'
    t.rspec_opts = ['-cfs']
  end
end

namespace :db do
  desc 'Auto-migrate the database (destroys data)'
  task :migrate => :environment do
    DataMapper.auto_migrate!
  end

  desc 'Auto-upgrade the database (preserves data)'
  task :upgrade => :environment do
    DataMapper.auto_upgrade!
  end
end

task :environment do
  require File.join(File.dirname(__FILE__), 'environment')
end

task :irc do
  options = {
    :app_name   => "showbot_irc",
    :multiple   => false,
    :ontop      => false,
    :dir_mode   => :script,
    :dir        => 'pid',
    :mode       => :load,
    :backtrace  => true,
    :log_output => true,
    :monitor    => true
  }


  Daemons.run('showbot.rb', options)
end
