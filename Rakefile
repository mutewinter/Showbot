require 'rubygems'
require 'bundler/setup'
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

namespace :backup do 
  task :run do
    run "backup perform -t showbot_backup -c './config/backup.rb'"
  end
end

namespace :foreman do
  desc 'Create /etc/init/showbot'
  task :create_init do 
    sh 'sudo foreman export upstart /etc/init -a showbot -u deploy web=3 irc=1'
  end
end
