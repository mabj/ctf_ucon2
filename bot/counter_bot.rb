#!/usr/bin/ruby
# TODO: Sacar- http://www.ruby-doc.org/core/classes/File/Stat.html
#

require 'sqlite3'
require 'logger'

HOME_DIR = '/home/'
LOG_FILE = 'ctf_ucon2.log'
SQLITE_DATABASE_FILE = 'ucon2.db'

# TODO: Jogar isso aqui para um YAML
CHALLENGE_STATS = {
  'ch_01' => {
    'category' => 'crack',
    'score' => '1',
    'uid' => 'challenge_01',
    'level' => '1'
  }, 
  'ch_02' => {
    'category' => '',
    'score' => '',
    'uid' => 'challenge_02',
    'level' => '1'
  }
}


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
      users = __list_users()
      users.each { |user|
        __update_user_score(user)
      }
      sleep(@sleep_time)
    end
  end

  private
  def __update_user_score(user = '')
    @logger.info("Updating [#{user}] score ...")
    results = __get_results()
    
    results.each { |r|
      file_name = r.split('/').last
      file_stat = File::Stat.new(r)
      
      
    }
  end

  def __get_results 
    crackme = Dir.glob(@home + '/ucon2/crackme/*_response')
    vulndev = Dir.glob(@home + '/ucon2/vulndev/*_response')
    special = Dir.glob(@home + '/ucon2/holygrail/*_response')
    
    crackme + vulndev + special
  end

  def __list_users()
    Dir.glob(@home + '/*')
  end
end



logger = Logger.new(LOG_FILE)
logger.level = Logger::DEBUG
logger.info('Starting the capture the flag bot ... ')

logger.info('Connecting with database ... ')
SQLite3::Database.new(SQLITE_DATABASE_FILE)

bot = CTFBot.new(HOME_DIR, 10, logger)
bot.run
