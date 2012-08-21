# schedule_production.rb
#
# Whenever gem's crontab schedule for Showbot in production

set :environment, "production"

set :output, '/var/log/showbot/crontab.log'

# Fixed for Rack
job_type :rake, "cd :path && RACK_ENV=:environment bundle exec rake :task --silent :output"

every 1.day, :at => '3:00am' do
  rake 'backup:run'
end
