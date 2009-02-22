################################################################################
# Ucon Security Conference II - Capture The Flag - Recife Brazil 2009
# Author:       Marcos Alvares marcos.alvares at gmail.com
# Description:  Este script irá criar um servidor para exibir o placar do CTF em
#               tempo real para os competidores. Ele faz uso da base sqlite
#               gerada e alimentada pelo bot

#!/usr/bin/ruby
require 'socket'
require 'logger'
require 'erb'
require 'sqlite3'

LIMIT_USERS = 100
SLEEP_TIME  = 5
SQLITE_DATABASE_FILE = '../../../bot/ucon2.db'
PORT = 23

server = TCPServer.new(PORT)

template = sprintf("%s\n", File.new('score.erb').readlines.join)
@erb = ERB.new(template, 0, "%<>")

@dbh = SQLite3::Database.new(SQLITE_DATABASE_FILE)

@logger = Logger.new(STDOUT)
@logger.level = Logger::INFO
@logger.info('Iniciando o telnetd')

@user_counter = 0

loop do
  Thread.start(server.accept) do |socket|
    socket.puts "\n" * 40
    @user_counter += 1

    if @user_counter <= LIMIT_USERS
      @logger.info("[+] Novo cliente [#{Thread.current.object_id.abs}] estabeleceu a conexao")
      @logger.info("[+] O sistema possui [#{@user_counter}] clientes conectados")
      loop do
        begin
          @score = @dbh.execute('select users.name, sum(challenges.score) as total from users, challenges_users, challenges where users.id = challenges_users.user_id AND challenges.uid = challenges_users.challenge_id group by users.name order by total desc;')
          users_without_score = @dbh.execute('select name, "0" from users where id NOT IN (select user_id from challenges_users group by user_id)')

          @score += users_without_score
          socket.puts @erb.result(binding)
          sleep(SLEEP_TIME)
          socket.puts "\n" * 40
        rescue Exception => e
          @logger.info("[+] cliente [#{Thread.current.object_id.abs}] encerrou a conexao")
          @user_counter -= 1
          @logger.info("[+] O sistema possui [#{@user_counter}] clientes conectados")
          break
        end # begin
      end # loop
      socket.close
    else
      @logger.info('[!] O sistema está lotado !')
      @user_counter -= 1
      socket.puts '[!] Sorry ...'
      socket.puts '[!] The system was limited for 100 participants. Try again later ...'
      socket.close
    end # if
  end # thread
end
