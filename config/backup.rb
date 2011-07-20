##
# Backup
# Generated Template
#
# For more information:
#
# View the Git repository at https://github.com/meskyanichi/backup
# View the Wiki/Documentation at https://github.com/meskyanichi/backup/wiki
# View the issue log at https://github.com/meskyanichi/backup/issues
#
# When you're finished configuring this configuration file,
# you can run it from the command line by issuing the following command:
#
# $ backup perform -t my_backup [-c <path_to_configuration_file>]

Backup::Model.new(:showbot_backup, 'Showbot Backup') do

  ##
  # MySQL [Database]
  #
  database MySQL do |db|
    db.name               = ENV['SHOWBOT_DATABASE_NAME']
    db.username           = ENV['SHOWBOT_DATABASE_USER']
    db.password           = ENV['SHOWBOT_DATABASE_PASSWORD']
    db.host               = "localhost"
    db.port               = 3306
    db.additional_options = ['--quick', '--single-transaction']
  end

  compress_with Gzip do |compression|
    compression.best = true
  end 

  store_with Dropbox do |db|
    db.email      = ENV['SHOWBOT_DROPBOX_USER']
    db.password   = ENV['SHOWBOT_DROPBOX_PASSWORD']
    db.api_key    = ENV['SHOWBOT_DROPBOX_API_KEY']
    db.api_secret = ENV['SHOWBOT_DROPBOX_API_SECRET']
    db.path       = '/backups'
    db.keep       = 25
    db.timeout    = 300 
  end 

end

