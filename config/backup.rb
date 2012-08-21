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

  store_with S3 do |s3|
    s3.access_key_id      = ENV['SHOWBOT_S3_ACCESS_KEY']
    s3.secret_access_key  = ENV['SHOWBOT_S3_SECRET_KEY']
    s3.region             = 'us-east-1'
    s3.bucket             = 'showbot'
    s3.path               = '/backups'
    s3.keep               = 10
  end

end

