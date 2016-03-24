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
    db.name               = ENV['BOT_DATABASE_NAME']
    db.username           = ENV['BOT_DATABASE_USER']
    db.password           = ENV['BOT_DATABASE_PASSWORD']
    db.host               = ENV['BOT_DATABASE_HOST']
    db.port               = ENV['BOT_DATABASE_PORT']
    db.additional_options = ENV['BOT_DATABASE_OPTS']
  end

  compress_with Gzip do |compression|
    compression.best = true
  end

  store_with S3 do |s3|
    s3.access_key_id      = ENV['BOT_S3_ACCESS_KEY']
    s3.secret_access_key  = ENV['BOT_S3_SECRET_KEY']
    s3.region             = ENV['BOT_S3_REGION']
    s3.bucket             = ENV['BOT_S3_BUCKET']
    s3.path               = ENV['BOT_S3_PATH']
    s3.keep               = ENV['BOT_S3_KEEP']
  end

end

