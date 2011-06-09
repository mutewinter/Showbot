require 'daemons'


options = {
  :app_name   => "showbot",
  :multiple   => false,
  :ontop      => true,
  :dir_mode   => :script,
  :dir        => 'pid',
  :mode       => :load,
  :backtrace  => true,
  :log_output => true,
  :monitor    => true
}


Daemons.run('showbot.rb', options)

