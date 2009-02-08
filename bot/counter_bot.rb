#!/usr/bin/ruby
# TODO: Sacar- http://www.ruby-doc.org/core/classes/File/Stat.html
#

require 'sqlite3'
require 'logger'

HOME_DIR = '/home/'
LOG_FILE = STDOUT# 'ctf_ucon2.log'
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
      @logger.debug('main loop iteration')
      users = __list_users()
      users.each { |user|
        __update_user_score(user)
      }
      sleep(@sleep_time)
    end
  end

  private
  def __create_user_if_not_exists (user_name = '')
    rows = @dbh.execute('select name, mail from users where name = ?', user_name)
    if rows.size.zero?
      @logger.info("Creating new user [#{user_name}]")
      @dbh.execute('insert into users values (NULL, ?, "automatic@mail")', user_name)
    end
  end

  def __register_user_point(challenge_id = 0, user_id = 0, user_name = '')
    rows = @dbh.execute('select user_id, challenge_id from user_challenges where challenge_id = ? AND user_id = ?')
    if rows.size.zero?
      @logger.info("Mark a point to user: #{user_name}")
      @dbh.execute('insert into user_challenges values (?, ?)', challenge_id, user_id)
    end
  end

  def __update_user_score(user_home = '')
    user = user_home.split('/').last
    __create_user_if_not_exists(user)

    @logger.debug("Updating [#{user}] score ...")
    result_files = __get_results(user)

    result_files.each { |r|
      file_name = r.split('\/').last
      file_stat = File::Stat.new(r)
      rows = @dbh.execute('SELECT id, uid from challenges where uid = ?', file_stat.uid)
      unless rows.size.zero?
        __register_user_point(rows.first[0], rows.first[1], user)
      end

      File.unlink(r)
    }
  end

  def __get_results (user)
    crackme = Dir.glob(@home_dir + user + '/ucon2/crackme/*/score/*_response')
    vulndev = Dir.glob(@home_dir + user  + '/ucon2/vulndev/*/score/*_response')
    special = Dir.glob(@home_dir + user + '/ucon2/holygrail/*/score/*_response')

    crackme + vulndev + special
  end

  def __list_users()
    Dir.glob(@home_dir + "\/*")
  end
end



logger = Logger.new(LOG_FILE)
logger.level = Logger::INFO
logger.info('Starting the capture the flag bot ... ')

logger.info('Connecting with database ... ')
dbh = SQLite3::Database.new(SQLITE_DATABASE_FILE)

bot = CTFBot.new(HOME_DIR, 10, logger, dbh)
bot.run
