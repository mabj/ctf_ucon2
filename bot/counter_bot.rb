#!/usr/bin/ruby
#
require 'sqlite3'
require 'logger'

HOME_DIR = '/home/'
LOG_FILE = 'ctf_ucon2.log'
SQLITE_DATABASE_FILE = 'ucon2.db'

class CTFBot
  attr_accessor :home_dir, :sleep_time
  def initialize(home_dir = '', sleep_time = 10, logger = nil, dbh = nil)
    @home_dir = home_dir
    @sleep_time = sleep_time
    @logger = logger || Logger.new(STDOUT)
    @dbh = dbh
  end

  def run
    while true
      @logger.info('main loop iteration')
      sleep(@sleep_time)
    end
  end
end



logger = Logger.new(LOG_FILE)
logger.level = Logger::DEBUG
logger.info('Starting the capture the flag bot ... ')

logger.info('Connecting with database ... ')
SQLite3::Database.new(SQLITE_DATABASE_FILE)

bot = CTFBot.new(HOME_DIR, 10, logger)
bot.run
