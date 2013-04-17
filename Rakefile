require 'rake/testtask'
require 'bundler/setup'


namespace :test do
  Rake::TestTask.new do |t|
    t.libs << "test"
    t.test_files = FileList['test/*test.rb']
    t.verbose = true
  end
end

# -----------------------
# Database
# -----------------------

namespace :db do
  desc 'Auto-migrate the database (destroys data)'
  task :migrate => :environment do
    puts "This will destroy all data in the _#{ENV['RACK_ENV']}_ database, continue? (yN)"
    if STDIN::gets.strip.downcase == 'y'
      DataMapper.auto_migrate!
    else
      puts "Okay, exiting."
    end
  end

  desc 'Auto-upgrade the database (preserves data)'
  task :upgrade => :environment do
    DataMapper.auto_upgrade!
  end

  desc 'Seed the database with some fake title suggestions'
  task :seed => :environment do
    5.times do |n|
      Suggestion.create(
        :title => "Test #{Time.now.to_i} #{n}",
        :show => 'b2w',
        :user => 'derp'
      )
    end
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

# -----------------------
# SASS
# -----------------------

namespace :sass do
  desc 'Watches and compiles sass to proper directory'
  task :watch => :environment do
    sh 'sass --watch -r ./sass/bourbon/lib/bourbon.rb sass/showbot.scss:public/css/showbot.css'
  end
end

# -----------------------
# Api Key Tasks
# -----------------------

namespace :api_key do
  desc 'Generates an Api Key for Showbot and prints it out to the console.'
  task :generate => :environment do
    print "Application Name (required): "
    app_name = STDIN::gets.chomp.strip
    key = ApiKey.create(app_name: app_name)
    if app_name
      puts "Here's the Api key for #{app_name}: #{key.value}"
    else
      puts "App name required to make a key. We gotta keep track of this stuff."
    end
  end
end
