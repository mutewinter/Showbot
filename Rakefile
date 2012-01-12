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
    `backup perform -t showbot_backup -c './config/backup.rb'`
  end
end

namespace :foreman do
  desc 'Export foreman upstart config for Showbot'
  task :export do 
    sh 'sudo foreman export upstart /etc/init -a showbot -p 5000 -u deploy'
  end
end

namespace :sass do
  desc 'Watches and compiles sass to proper directory'
  task :watch => :environment do
    sh 'sass --watch -r ./sass/bourbon/lib/bourbon.rb sass/showbot.scss:public/css/showbot.css'
  end
end
